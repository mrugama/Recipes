import XCTest
@testable import Storage
@testable import Networking
@testable import RecipeRestAPI

final class MockDataLoader: DataLoader {
    var mockResponses: [String: Result<Data, Error>]
    
    init() {
        mockResponses = [:]
    }

    func load(urlStr: String) async throws -> Data {
        if let result = mockResponses[urlStr] {
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                throw error
            }
        }
        throw URLError(.badURL)
    }
}

extension MockDataLoader: @unchecked Sendable {}

final class MockStorage: Storage {
    var mockStorage: [String: Data]
    
    init() {
        self.mockStorage = [:]
    }

    func save(_ imageID: String, data: Data) throws {
        mockStorage[imageID] = data
    }
    
    func getImageData(_ imageID: String) throws -> Data? {
        return mockStorage[imageID]
    }
    
    func clearCachedDirectory() throws {
        // Fake clear cache
    }
}

extension MockStorage: @unchecked Sendable {}

// MARK: - Unit Test Class
final class RecipeRestAPITests: XCTestCase {
    var mockDataLoader: MockDataLoader!
    var mockStorage: MockStorage!
    var api: RecipeRestAPI!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDataLoader = MockDataLoader()
        mockStorage = MockStorage()
        api = ConcreteRecipeRestAPI(
            dataLoaderService: MockDataLoaderService(mockDataLoader),
            storageService: MockStorageService(mockStorage)
        )
    }

    override func tearDownWithError() throws {
        mockDataLoader = nil
        mockStorage = nil
        api = nil
        try super.tearDownWithError()
    }

    // MARK: - Test fetchRecipes(_:)
    func testFetchRecipesWithValidEndpoint() async throws {
        // Given
        let endpoint = RecipeEndpoint.valid
        let mockJSON = """
        {
            "recipes": [
                {
                    "cuisine": "Italian",
                    "name": "Pizza",
                    "photo_url_large": "https://example.com/large",
                    "photo_url_small": "https://example.com/small",
                    "source_url": "https://example.com/source",
                    "uuid": "12345",
                    "youtube_url": "https://youtube.com"
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        mockDataLoader.mockResponses[endpoint.urlStr] = .success(mockJSON)
        let recipes = try await api.fetchRecipes(endpoint)

        // Then
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.name, "Pizza")
        XCTAssertEqual(recipes.first?.cuisine, "Italian")
    }

    func testFetchRecipesWithMalformedData() async throws {
        // Given
        let endpoint = RecipeEndpoint.malformed
        let mockInvalidJSON = "Invalid JSON".data(using: .utf8)!
        
        // When
        mockDataLoader.mockResponses[endpoint.urlStr] = .success(mockInvalidJSON)

        // Then
        do {
            _ = try await api.fetchRecipes(endpoint)
            XCTFail("Decoding should fail for malformed JSON.")
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
    }
    
    // MARK: - Test fetchImage(with:)
    func testFetchImageFromCache() async throws {
        // Given
        let imageURL = "https://example.com/image"
        let imageData = "TestImageData".data(using: .utf8)!

        // When
        try mockStorage.save(imageURL, data: imageData)
        let fetchedData = try await api.fetchImage(with: imageURL)

        // Then
        XCTAssertNotNil(fetchedData)
        XCTAssertEqual(fetchedData, imageData, "Image data should come from cache.")
    }
    
    func testFetchImageFromNetwork() async throws {
        // Given
        let imageURL = "https://example.com/image"
        let imageData = "TestImageDataFromNetwork".data(using: .utf8)!

        // When
        mockDataLoader.mockResponses[imageURL] = .success(imageData)
        let fetchedData = try await api.fetchImage(with: imageURL)

        // Then
        XCTAssertNotNil(fetchedData)
        XCTAssertEqual(fetchedData, imageData, "Image data should come from network.")
    }
}

// MARK: - Mock Service Providers
class MockDataLoaderService: DataLoaderService {
    private let mockDataLoader: MockDataLoader
    
    init(_ mockDataLoader: MockDataLoader) {
        self.mockDataLoader = mockDataLoader
    }
    
    func provideDataLoader() -> any DataLoader {
        return mockDataLoader
    }
}

class MockStorageService: StorageService {
    private let mockStorage: MockStorage
    
    init(_ mockStorage: MockStorage) {
        self.mockStorage = mockStorage
    }
    
    func provideStorage() -> any Storage {
        return mockStorage
    }
}

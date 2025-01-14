import Testing
import Foundation
@testable import Storage
@testable import Networking
@testable import RecipeRestAPI

@Suite("Rest API")
struct RestAPITests {
    
    struct EndpointTests {
        var mockDataLoader: MockDataLoader
        var mockStorage: MockStorage
        var api: RecipeRestAPI
        
        init() {
            mockDataLoader = MockDataLoader()
            mockStorage = MockStorage()
            api = ConcreteRecipeRestAPI(
                dataLoaderService: MockDataLoaderService(mockDataLoader),
                storageService: MockStorageService(mockStorage)
            )
        }
        
        @Test("Endpoint with valid response")
        func validResponse() async throws {
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
            #expect(recipes.count == 1)
            #expect(recipes[0].name == "Pizza")
            #expect(recipes[0].cuisine == "Italian")
        }
        
        @Test("Endpoint with malformed response")
        func malformedResponse() async throws {
            let endpoint = RecipeEndpoint.malformed
            let mockInvalidJSON = "Invalid JSON".data(using: .utf8)!
            
            // When
            mockDataLoader.mockResponses[endpoint.urlStr] = .success(mockInvalidJSON)
            
            // Then
            do {
                let _ = try await api.fetchRecipes(endpoint)
                Issue.record("Data corrupted or malformed.")
            } catch {
                #expect(error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format.")
            }
        }
        
        @Test("Endpoint with empty response")
        func emptyResponse() async throws {
            let endpoint = RecipeEndpoint.empty
            let mockInvalidJSON = "".data(using: .utf8)!
            
            // When
            mockDataLoader.mockResponses[endpoint.urlStr] = .success(mockInvalidJSON)
            
            // Then
            do {
                let _ = try await api.fetchRecipes(endpoint)
                Issue.record("Empty.")
            } catch {
                #expect(error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format.")
            }
        }
    }
    
    struct ImageCacheTests {
        var mockDataLoader: MockDataLoader
        var mockStorage: MockStorage
        var api: RecipeRestAPI
        
        init() {
            mockDataLoader = MockDataLoader()
            mockStorage = MockStorage()
            api = ConcreteRecipeRestAPI(
                dataLoaderService: MockDataLoaderService(mockDataLoader),
                storageService: MockStorageService(mockStorage)
            )
        }
        
        @Test("Fetch image from cache.")
        func imageFromCache() async throws {
            // Given
            let imageURL = "https://example.com/image"
            let imageData = "TestImageData".data(using: .utf8)!
            
            // When
            try await mockStorage.save(imageURL, data: imageData)
            let fetchedData = try await api.fetchImage(with: imageURL)
            
            // Then
            let data = try #require(fetchedData)
            #expect(data == imageData)
        }
        
        @Test("Fetch image from online.")
        func imageFromOnline() async throws {
            // Given
            let imageURL = "https://example.com/image"
            let imageData = "TestImageDataFromNetwork".data(using: .utf8)!

            // When
            mockDataLoader.mockResponses[imageURL] = .success(imageData)
            let fetchedData = try await api.fetchImage(with: imageURL)

            // Then
            let data = try #require(fetchedData)
            #expect(data == imageData)
        }
    }
}

// MARK: - Mock Service Providers
final class MockDataLoaderService: DataLoaderService {
    private let mockDataLoader: MockDataLoader
    
    init(_ mockDataLoader: MockDataLoader) {
        self.mockDataLoader = mockDataLoader
    }
    
    func provideDataLoader() -> any DataLoader {
        return mockDataLoader
    }
}

final class MockStorageService: StorageService {
    private let mockStorage: MockStorage
    
    init(_ mockStorage: MockStorage) {
        self.mockStorage = mockStorage
    }
    
    func provideStorage() -> any Storage {
        return mockStorage
    }
}

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

actor MockStorage: Storage {
    var mockStorage: [String: Data]
    
    init() {
        self.mockStorage = [:]
    }

    func save(_ imageID: String, data: Data) async throws {
        mockStorage[imageID] = data
    }
    
    func getImageData(_ imageID: String) async throws -> Data? {
        return mockStorage[imageID]
    }
    
    func clearCachedDirectory() async throws {
        // Fake clear cache
    }
    
    func getHash(from data: Data) async throws -> String {
        ""
    }
    
    func getLocalHash() async -> String? {
        ""
    }
    
    func shouldFetchOnline(remoteHash: String) async -> Bool {
        false
    }
}

extension MockStorage: @unchecked Sendable {}

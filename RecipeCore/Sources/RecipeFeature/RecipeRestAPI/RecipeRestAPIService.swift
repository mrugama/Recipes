import Foundation
import Networking
import Storage

public struct Recipe: Decodable, Hashable, Sendable {
    public let cuisine: String
    public let name: String
    public let photoUrlLarge: String?
    public let photoUrlSmall: String?
    public let sourceUrl: String?
    public let uuid: String
    public let youtubeUrl: String?
    public var imageData: Data? 
    
    public init(
        cuisine: String,
        name: String,
        photoUrlLarge: String?,
        photoUrlSmall: String?,
        sourceUrl: String?,
        uuid: String,
        youtubeUrl: String?
    ) {
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.sourceUrl = sourceUrl
        self.uuid = uuid
        self.youtubeUrl = youtubeUrl
    }
}

public enum RecipeEndpoint: String, CaseIterable {
    case valid, malformed, empty
}

public protocol RecipeRestAPI where Self: Sendable {
    func fetchRecipes(_ endpoint: RecipeEndpoint) async throws -> [Recipe]
    func fetchImage(with urlStr: String) async throws -> Data?
    func clearCache() throws
}

public protocol RecipeRestAPIService {
    func provideRecipeRestAPI() -> any RecipeRestAPI
}

public struct ConcreteRecipeRestAPIService: RecipeRestAPIService {
    private let dataLoaderService: DataLoaderService
    private let storageService: StorageService
    
    public func provideRecipeRestAPI() -> any RecipeRestAPI {
        ConcreteRecipeRestAPI(
            dataLoaderService: dataLoaderService,
            storageService: storageService
        )
    }
    
    public init(
        dataLoaderService: DataLoaderService,
        storageService: StorageService
    ) {
        self.dataLoaderService = dataLoaderService
        self.storageService = storageService
    }
}

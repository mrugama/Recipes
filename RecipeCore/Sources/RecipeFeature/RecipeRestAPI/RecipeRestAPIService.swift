import Foundation
import Networking
import Storage

public protocol RecipeModel
where Self: Decodable,
      Self: Hashable,
      Self: Sendable {
    var cuisine: String { get }
    var name: String { get }
    var photoUrlLarge: String? { get }
    var photoUrlSmall: String? { get }
    var sourceUrl: String? { get }
    var uuid: String { get }
    var youtubeUrl: String? { get }
    var imageData: Data? { get }
}

public enum RecipeEndpoint: String, CaseIterable, Sendable {
    case valid, malformed, empty
}

public protocol RecipeRestAPI
where Self: Sendable,
      Self: Actor {
    func fetchRecipes(_ endpoint: RecipeEndpoint) async throws -> [any RecipeModel]
    func fetchImage(with urlStr: String) async throws -> Data?
    func clearCache() async throws
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

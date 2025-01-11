import Foundation
import Networking
import Storage
import SwiftData

@Model
public final class Recipe: Decodable, @unchecked Sendable {
    enum CodingKeys: CodingKey {
        case cuisine, name, photo_url_large,
             photo_url_small, source_url,
             uuid, youtube_url, imageData
    }
    public var cuisine: String
    public var name: String
    @Attribute(originalName: "photo_url_large")
    public var photoUrlLarge: String?
    @Attribute(originalName: "photo_url_small")
    public var photoUrlSmall: String?
    @Attribute(originalName: "source_url")
    public var sourceUrl: String?
    public var uuid: String
    @Attribute(originalName: "youtube_url")
    public var youtubeUrl: String?
    public var imageData: Data?
    
    public init(cuisine: String, name: String, photoUrlLarge: String?, photoUrlSmall: String?, sourceUrl: String?, uuid: String, youtubeUrl: String?, imageData: Data? = nil) {
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.sourceUrl = sourceUrl
        self.uuid = uuid
        self.youtubeUrl = youtubeUrl
        self.imageData = imageData
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        name = try container.decode(String.self, forKey: .name)
        photoUrlLarge = try container.decodeIfPresent(String.self, forKey: .photo_url_large)
        photoUrlSmall = try container.decodeIfPresent(String.self, forKey: .photo_url_small)
        sourceUrl = try container.decodeIfPresent(String.self, forKey: .source_url)
        uuid = try container.decode(String.self, forKey: .uuid)
        youtubeUrl = try container.decodeIfPresent(String.self, forKey: .youtube_url)
    }
}

public enum RecipeEndpoint: String, CaseIterable, Sendable {
    case valid, malformed, empty
}

public protocol RecipeRestAPI
where Self: Sendable,
      Self: Actor {
    var shouldOverrideRecipe: Bool { get }
    func fetchRecipes(_ endpoint: RecipeEndpoint) async throws -> [Recipe]
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

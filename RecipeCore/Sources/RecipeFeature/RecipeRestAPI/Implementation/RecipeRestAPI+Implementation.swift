import Foundation
import Networking
import Storage

struct Model: Decodable {
    let recipes: [Recipe]
}

struct ConcreteRecipeRestAPI: RecipeRestAPI {
    private let dataLoader: any DataLoader
    private let storage: any Storage
    
    init(
        dataLoaderService: DataLoaderService,
        storageService: StorageService
    ) {
        self.dataLoader = dataLoaderService.provideDataLoader()
        self.storage = storageService.provideStorage()
    }
    
    func fetchRecipes(_ endpoint: RecipeEndpoint) async throws -> [Recipe] {
        let dataResponse = try await dataLoader.load(urlStr: endpoint.urlStr)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let model = try decoder.decode(Model.self, from: dataResponse)
        return model.recipes
    }
    
    func fetchImage(with urlStr: String) async throws -> Data? {
        let cacheData = try? storage.getImageData(urlStr)
        if let cacheData = cacheData {
            return cacheData
        }
        
        let data = try? await dataLoader.load(urlStr: urlStr)
        return data
    }
    
    func clearCache() throws {
        try storage.clearCachedDirectory()
    }
}

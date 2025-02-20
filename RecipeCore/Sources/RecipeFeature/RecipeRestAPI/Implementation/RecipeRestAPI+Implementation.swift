import Foundation
import Networking
import Storage

struct Model: Decodable, Sendable {
    let recipes: [Recipe]
}

actor ConcreteRecipeRestAPI: RecipeRestAPI {
    private let dataLoader: any DataLoader
    private let storage: any Storage
    private var recipes: [Recipe] = []
    var shouldOverrideRecipe: Bool = false
    
    init(
        dataLoaderService: DataLoaderService,
        storageService: StorageService
    ) {
        self.dataLoader = dataLoaderService.provideDataLoader()
        self.storage = storageService.provideStorage()
    }
    
    func fetchRecipes(_ endpoint: RecipeEndpoint) async throws -> [Recipe] {
        let dataResponse = try await dataLoader.load(urlStr: endpoint.urlStr)
        let shouldOverride = try await shouldOverride(dataResponse)
        if shouldOverride || recipes.isEmpty {
            let decoder = JSONDecoder()
            async let model = try decoder.decode(Model.self, from: dataResponse)
            recipes = try await model.recipes
            shouldOverrideRecipe = true
        }
        return recipes
    }
    
    func fetchImage(with urlStr: String) async throws -> Data? {
        let cacheData = try? await storage.getImageData(urlStr)
        if let cacheData = cacheData {
            return cacheData
        }
        
        let data = try? await dataLoader.load(urlStr: urlStr)
        return data
    }
    
    func clearCache() async throws {
        try await storage.clearCachedDirectory()
    }
    
    // MARK: - Helper method
    private func shouldOverride(_ data: Data) async throws -> Bool {
        let remoteHash = try await storage.getHash(from: data)
        return await storage.shouldFetchOnline(remoteHash: remoteHash)
    }
}

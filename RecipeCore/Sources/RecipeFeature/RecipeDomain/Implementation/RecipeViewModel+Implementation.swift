import Foundation
import RecipeRestAPI
import SwiftUI

@MainActor
@Observable
final class ConcreteRecipeViewModel: RecipeViewModel {
    private(set) var allRecipes: [Recipe] = []
    var cacheImages: [String: Data] = [:]
    var cusines: [String : [Recipe]] {
        Dictionary(
            grouping: allRecipes,
            by: { $0.cuisine }
        )
    }
    private(set) var output: String?
    private(set) var recipeRestAPI: RecipeRestAPI
    
    init(recipeRestAPIService: RecipeRestAPIService) {
        recipeRestAPI = recipeRestAPIService.provideRecipeRestAPI()
    }
    
    func loadRecipes(_ endpoint: RecipeEndpoint = .valid) {
        output = "Fetching recipes..."
        Task {
            do {
                let recipes = try await recipeRestAPI.fetchRecipes(endpoint)
                if recipes.isEmpty {
                    output = "No recipes found."
                } else {
                    output = nil
                    
                    allRecipes = recipes
                }
            } catch {
                output = error.localizedDescription
            }
        }
    }
    
    func getImageData(_ imageUrl: String) async {
        let imageData = try? await recipeRestAPI.fetchImage(with: imageUrl)
        cacheImages[imageUrl] = imageData
    }
    
    func clearCache() {
        try? recipeRestAPI.clearCache()
    }
}

import Foundation
import RecipeRestAPI
import SwiftUI

@MainActor
@Observable
final class ConcreteRecipeViewModel: RecipeViewModel {
    private(set) var allRecipes: [Recipe] = []
    var cacheImages: [String: Data] = [:]
    private(set) var output: String?
    private(set) var recipeRestAPI: RecipeRestAPI
    var status: String?
    var shouldShowStatus: Bool = false
    var shouldOverrideRecipes: Bool = false
    
    init(recipeRestAPIService: RecipeRestAPIService) {
        recipeRestAPI = recipeRestAPIService.provideRecipeRestAPI()
    }
    
    func loadRecipes(_ endpoint: RecipeEndpoint = .valid) async {
        output = "Fetching recipes..."
        Task {
            do {
                let recipes = try await recipeRestAPI.fetchRecipes(endpoint)
                if recipes.isEmpty {
                    output = "No recipes found."
                    status = "Up to date. No data found"
                } else {
                    output = nil
                    status = "Up to date. \(recipes.count) recipes found"
                    allRecipes = recipes
                    shouldOverrideRecipes = await recipeRestAPI.shouldOverrideRecipe
                    shouldShowStatus = true
                }
            } catch {
                output = error.localizedDescription
                shouldShowStatus = false
            }
        }
    }
    
    func getImageData(_ imageUrl: String) async {
        let imageData = try? await recipeRestAPI.fetchImage(with: imageUrl)
        cacheImages[imageUrl] = imageData
    }
    
    func clearCache() {
        Task {
            try? await recipeRestAPI.clearCache()            
        }
    }
}

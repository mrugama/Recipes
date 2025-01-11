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
    var shouldShowStatus: Bool = true
    var shouldOverrideRecipes: Bool = false
    
    init(recipeRestAPIService: RecipeRestAPIService) {
        recipeRestAPI = recipeRestAPIService.provideRecipeRestAPI()
    }
    
    func loadRecipes(_ endpoint: RecipeEndpoint = .valid) async {
        output = "Fetching recipes..."
        shouldShowStatus = true
        Task {
            do {
                let recipes = try await recipeRestAPI.fetchRecipes(endpoint)
                shouldOverrideRecipes = await recipeRestAPI.shouldOverrideRecipe
                if recipes.isEmpty {
                    output = "No recipes found."
                    status = "Upda to date. No data found"
                } else {
                    output = nil
                    status = "Up to date. \(recipes.count) recipes found"
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
        Task {
            try? await recipeRestAPI.clearCache()            
        }
    }
}

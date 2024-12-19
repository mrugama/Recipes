import Foundation
import RecipeRestAPI

@MainActor
public protocol RecipeViewModel where Self: Observable {
    var allRecipes: [Recipe] { get }
    var cacheImages: [String: Data] { get }
    var cusines: [String: [Recipe]] { get }
    var output: String? { get }
    
    func loadRecipes(_ endpoint: RecipeEndpoint)
    func getImageData(_ imageUrl: String) async
    func clearCache()
}

public struct RecipeViewModelService {
    private let recipeRestAPIService: RecipeRestAPIService
    
    @MainActor
    public func provideViewModel() -> RecipeViewModel {
        ConcreteRecipeViewModel(
            recipeRestAPIService: recipeRestAPIService
        )
    }
    
    public init(recipeRestAPIService: RecipeRestAPIService) {
        self.recipeRestAPIService = recipeRestAPIService
    }
}

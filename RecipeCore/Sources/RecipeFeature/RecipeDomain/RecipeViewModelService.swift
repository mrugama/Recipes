import Foundation
import RecipeRestAPI

@MainActor
public protocol RecipeViewModel where Self: Observable {
    var allRecipes: [Recipe] { get }
    var cacheImages: [String: Data] { get }
    var output: String? { get }
    var status: String? { get set }
    var shouldOverrideRecipes: Bool { get set }
    var shouldShowStatus: Bool { get set }
    
    func loadRecipes(_ endpoint: RecipeEndpoint) async
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

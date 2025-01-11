import RecipeDomain
import RecipeRestAPI
import SwiftData
import SwiftUI

public enum ViewProvider {
    @MainActor public static func recipePage(
        viewModelService: RecipeViewModelService
    ) -> some View {
        RecipePageView(service: viewModelService)
            .modelContainer(for: Recipe.self)
    }
}

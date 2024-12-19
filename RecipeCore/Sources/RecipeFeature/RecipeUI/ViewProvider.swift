import SwiftUI
import RecipeDomain

public enum ViewProvider {
    @MainActor public static func recipePage(
        viewModelService: RecipeViewModelService
    ) -> some View {
        RecipePageView(service: viewModelService)
    }
}

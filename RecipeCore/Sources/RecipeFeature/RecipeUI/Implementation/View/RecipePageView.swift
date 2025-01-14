import RecipeDomain
import RecipeRestAPI
import SwiftUI
import SwiftData

struct RecipePageView: View {
    @State private var viewModel: RecipeViewModel
    @Environment(\.modelContext) private var modelContext
    @Query var recipes: [Recipe]
    
    var cusines: [String : [Recipe]] {
        Dictionary(
            grouping: recipes,
            by: { $0.cuisine }
        )
    }
    
    init(service: RecipeViewModelService) {
        self.viewModel = service.provideViewModel()
    }
    
    var body: some View {
        List {
            if let output = viewModel.output {
                OutputView(message: LocalizedStringKey(output)) {
                    await viewModel.loadRecipes(.valid)
                }
            } else {
                ForEach(Array(cusines.keys), id: \.self) { key in
                    Section(header: Text(key).font(.headline)) {
                        ForEach(Array(cusines[key]!), id: \.uuid) { recipe in
                            let image = getImage(from: viewModel.cacheImages[recipe.photoUrlSmall!])
                            return RecipeRowView(imageView: image, title: recipe.name)
                                .task {
                                    await viewModel.getImageData(recipe.photoUrlSmall!)
                                }
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            StatusView(message: viewModel.status, show: $viewModel.shouldShowStatus)
        }
        .task {
            await viewModel.loadRecipes(.valid)
        }
        .task(id: viewModel.shouldOverrideRecipes) {
            if viewModel.shouldOverrideRecipes {
                try? modelContext.delete(model: Recipe.self)
                viewModel.allRecipes.forEach { recipe in
                    modelContext.insert(recipe)
                    viewModel.shouldOverrideRecipes = false
                }
                try? modelContext.save()
            }
        }
        .refreshable {
            await viewModel.loadRecipes(.valid)
        }
        .listStyle(.grouped)
    }
    
    private func getImage(from imageData: Data?) -> Image {
        if let imageData = imageData {
            return Image(uiImage: UIImage(data: imageData)!)
        }
        return Image(systemName: "fork.knife")
    }
}

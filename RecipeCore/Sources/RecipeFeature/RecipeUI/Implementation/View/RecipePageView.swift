import RecipeDomain
import SwiftUI

struct RecipePageView: View {
    @State private var viewModel: RecipeViewModel
    
    init(service: RecipeViewModelService) {
        self.viewModel = service.provideViewModel()
    }
    
    var body: some View {
        List {
            if let output = viewModel.output {
                OutputView(message: LocalizedStringKey(output))
            } else {
                ForEach(Array(viewModel.cusines.keys), id: \.self) { key in
                    Section(header: Text(key).font(.headline)) {
                        ForEach(Array(viewModel.cusines[key]!), id: \.uuid) { recipe in
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
            StatusView(message: viewModel.status)
        }
        .task {
            viewModel.loadRecipes(.valid)
        }
        .refreshable {
            viewModel.loadRecipes(.valid)
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

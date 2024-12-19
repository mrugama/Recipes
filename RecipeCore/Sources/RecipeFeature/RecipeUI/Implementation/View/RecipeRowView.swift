import SwiftUI

struct RecipeRowView: View {
    var imageView: Image
    let title: String
    var body: some View {
        HStack(spacing: .x8) {
            imageView
                .resizable()
                .frame(width: .x64, height: .x64)
            Text(title)
        }
    }
}

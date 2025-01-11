import SwiftUI

struct RecipeRowView: View {
    var imageView: Image
    let title: String
    var body: some View {
        Label {
            Text(title)
                .padding(.leading, .x10)
        } icon: {
            imageView
                .resizable()
                .frame(width: .x64, height: .x64)
        }
        .padding()
    }
}

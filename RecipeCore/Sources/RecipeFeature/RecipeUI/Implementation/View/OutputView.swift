import SwiftUI

struct OutputView: View {
    var message: LocalizedStringKey
    var body: some View {
        Text(message)
            .font(.headline)
            .lineLimit(2)
            .padding()
    }
}


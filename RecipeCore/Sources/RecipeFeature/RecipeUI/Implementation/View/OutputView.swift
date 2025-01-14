import SwiftUI

struct OutputView: View {
    var message: LocalizedStringKey
    var action: () async -> Void = { }
    var body: some View {
        ContentUnavailableView {
            Image(systemName: "house.slash")
        } description: {
            Text(message)
                .font(.headline)
                .lineLimit(2)
                .padding()
        } actions: {
            Button(LocalizedStringKey("Retry")) {
                Task {
                    await action()
                }
            }
        }
    }
}


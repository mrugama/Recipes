import SwiftUI

struct StatusView: View {
    var message: String?
    @State private var opacity: Double = 1.0
    var body: some View {
        Text(message ?? "")
            .frame(maxWidth: .infinity)
            .font(.headline)
            .foregroundStyle(.white)
            .background(.green)
            .opacity(message != nil ? opacity: 0.0)
            .onAppear {
                opacity = 1.0
                let _delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: 2.0))
                RunLoop.main.schedule(after: _delay) {
                    withAnimation {
                        opacity = 0.0
                    }
                }
            }
    }
}

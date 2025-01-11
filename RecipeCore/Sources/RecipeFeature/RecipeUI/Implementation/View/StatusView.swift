import SwiftUI

struct StatusView: View {
    var message: String?
    @Binding var show: Bool
    var body: some View {
        Text(message ?? "")
            .frame(maxWidth: .infinity)
            .font(.headline)
            .foregroundStyle(.white)
            .background(.green)
            .opacity(show ? 1.0 : 0.0)
            .task(id: show) {
                let _delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: 2.0))
                RunLoop.main.schedule(after: _delay) {
                    withAnimation {
                        show = false
                    }
                }
            }
    }
}

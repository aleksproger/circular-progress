import SwiftUI

/// Modifier to simplify animation of examples in SwiftUI previews.
struct OnTimer: ViewModifier {
    let interval: TimeInterval
    let block: () -> Void
    
    init(_ interval: TimeInterval, _ block: @escaping () -> Void) {
        self.interval = interval
        self.block = block
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in withAnimation { block() } }
        }
    }
}

/// Syntax sugar for `ViewModifier`, based on Apple recomendations.
extension View {
    func onTimer(
        _ interval: TimeInterval = 0.1,
        _ block: @escaping () -> Void
    ) -> some View {
        modifier(OnTimer(interval, block))
    }
}

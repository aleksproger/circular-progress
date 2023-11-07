import SwiftUI
#if os(macOS)
import AppKit
#endif

/// Modifier to animate views based on the screen frame chagnes.
struct OnDisplayLink: ViewModifier {
    @ObservedObject
    var displayLink = DisplayLink.shared
    
    let block: () -> Void
    
    init(_ block: @escaping () -> Void) {
        self.block = block
        DisplayLink.shared.register()
    }
    
    func body(content: Content) -> some View {
        content
        .onChange(of: displayLink.frameChange) { _ in withAnimation { block() } }
    }
}

/// Syntax sugar for `ViewModifier`, based on Apple recomendations.
extension View {
    func onDisplayLink(
        _ block: @escaping () -> Void
    ) -> some View {
        modifier(OnDisplayLink(block))
    }
}

final class DisplayLink: NSObject, ObservableObject {
    @Published var frameChange: Bool = false
    
    static let shared = DisplayLink()
    
    func register() {
        #if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
                let displaylink = CADisplayLink(target: self, selector: #selector(frame))
                displaylink.add(to: .current, forMode: RunLoop.Mode.default)
        #elseif os(macOS)
            if #available(macOS 14.0, *) {
                guard let mainScreen = NSScreen.main else { return }
                let displaylink = mainScreen.displayLink(target: self, selector: #selector(frame))
                displaylink.add(to: .current, forMode: RunLoop.Mode.default)
            } else {
                Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] _ in
                    guard let self else { return }
                    frameChange.toggle()
                }
            }
        #endif
    }
    
    @available(macOS 14.0, *)
    @objc func frame(displaylink: CADisplayLink) {
        frameChange.toggle()
    }
}

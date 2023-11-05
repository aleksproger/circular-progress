import SwiftUI

/// Any custom style must conform to this protocol in order be used in `.progressStyle(_ style:)` view modifier.
public protocol CircularProgressStyle {
    associatedtype Body: View
    associatedtype State
    
    func makeBody(configuration: CircularProgressStyleConfiguration<State>) -> Body
}

public struct CircularProgressStyleConfiguration<State> {
    let lineWidth: CGFloat
    let state: State
    
    public init(lineWidth: CGFloat, state: State) {
        self.lineWidth = lineWidth
        self.state = state
    }
}

/// `CircleProgress` view modifier that allow applying of custom `CircularProgressStyle` style on the view.
/// Allow the client to create nw style with completly different layout and content, but preserving the same semantic of the `CircleProgress`.
/// Which is more advantageous and intuitive than creating additional wrappers.
extension CircularProgress {
    public func progressStyle<S: CircularProgressStyle>(_ style: S) -> some View where State == S.State {
        style.makeBody(configuration: CircularProgressStyleConfiguration<S.State>(lineWidth: lineWidth, state: state))
    }
}

/// Allows to use the style as `.progressStyle(.interactive)` instead of `.progressStyle(InteractiveCircularProgressStyle())``
extension CircularProgressStyle where Self == InteractiveCircularProgressStyle {
    public static var interactive: InteractiveCircularProgressStyle { InteractiveCircularProgressStyle() }
}

/// Allows to use the style as `.progressStyle(.simple)` instead of `.progressStyle(DefaultCircularProgressStyle())``
extension CircularProgressStyle where Self == DefaultCircularProgressStyle {
    public static var simple: DefaultCircularProgressStyle { DefaultCircularProgressStyle() }
}

/// Default style which will be applied to `CircularProgress` when no style is applied.
/// It looks as a simple loader of application's accentColor.
/// Use the style as `.progressStyle(.simple)` instead of `.progressStyle(DefaultCircularProgressStyle())``
public struct DefaultCircularProgressStyle: CircularProgressStyle {
    public func makeBody(configuration: CircularProgressStyleConfiguration<Double>) -> some View {
        CircularProgress(
            lineWidth: configuration.lineWidth,
            state: configuration.state,
            color: { _ in .accentColor }
        )
    }
}

/// Loader with accentColor color, Whihc shows green checkmark on `.succeeded` and red exclamation on `.failed`
/// Use the style as `.progressStyle(.interactive)` instead of `.progressStyle(InteractiveCircularProgressStyle())``
public struct InteractiveCircularProgressStyle: CircularProgressStyle {
    public func makeBody(configuration: CircularProgressStyleConfiguration<CircularProgressState>) -> some View {
        CircularProgress(
            lineWidth: configuration.lineWidth,
            state: configuration.state,
            color: { state in
                switch state {
                case .inProgress: .blue
                case .failed: .red
                case .succeeded: .green }
            }
        ) { progressState in
            switch progressState {
            case .inProgress: EmptyView()
            case .failed: ExclamationView(lineWidth: configuration.lineWidth).foregroundColor(.red)
            case .succeeded: CheckmarkView(lineWidth: configuration.lineWidth).foregroundColor(.green) }
        }
    }
}

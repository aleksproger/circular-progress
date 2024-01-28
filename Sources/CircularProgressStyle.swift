import SwiftUI

/// Any custom style must conform to this protocol in order be used in `.progressStyle(_ style:)` view modifier.
public protocol CircularProgressStyle {
    associatedtype Body: View
    associatedtype State: RawRepresentable where State.RawValue: BinaryFloatingPoint
    
    @ViewBuilder
    func makeBody(configuration: CircularProgressStyleConfiguration<State>) -> Body
}

public struct CircularProgressStyleConfiguration<State: RawRepresentable> where State.RawValue: BinaryFloatingPoint {
    public let lineWidth: CGFloat
    public let state: State
    
    public init(
        lineWidth: CGFloat,
        state: State
    ) {
        self.lineWidth = lineWidth
        self.state = state
    }
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

/// Loader with accentColor color, which shows green checkmark on `.succeeded` and red exclamation on `.failed`
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

/// Loader with accentColor color, which rotates in circle until the progressing is finished.
/// Use the style as `.progressStyle(.interactive)` instead of `.progressStyle(RotatingProgressStyle())``
public struct RotatingProgressStyle: CircularProgressStyle {
    public func makeBody(configuration: CircularProgressStyleConfiguration<Double>) -> some View {
        RotatingCircleProgress(lineWidth: configuration.lineWidth, state: configuration.state)
    }
}

/// Wrapper view needed to store rotation states.
///  Instance of this view returned by `RotatingProgressStyle`
struct RotatingCircleProgress<State: RawRepresentable>: View where State.RawValue: BinaryFloatingPoint {
    @SwiftUI.State
    private var angle: Double = 0
    
    @SwiftUI.State
    private var fraction: ClosedRange<State.RawValue> = 0...0.25
    
    let lineWidth: CGFloat
    let state: State
    let speed: Double
    
    init(
        lineWidth: CGFloat,
        state: State,
        speed: Double = 0.02
    ) {
        self.lineWidth = lineWidth
        self.state = state
        self.speed = speed
    }
        
    var body: some View {
        CircularProgress(
            lineWidth: lineWidth,
            state: state,
            fraction: fraction,
            color: { _ in .accentColor }
        )
        .rotationEffect(.radians(angle))
        .onDisplayLink { 
            angle += speed
            if state.rawValue >= 0.25 { fraction = 0...state.rawValue }
        }
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

/// Allows to use the style as `.progressStyle(.rotating)` instead of `.progressStyle(RotatingCircularProgressStyle())``
extension CircularProgressStyle where Self == RotatingProgressStyle {
    public static var rotating: RotatingProgressStyle { RotatingProgressStyle() }
}

import Foundation
import SwiftUI

/// View which provides progress circle UI and layouts custom content inside the circle.
public struct CircularProgress<State: RawRepresentable, Content: View>: View where State.RawValue: BinaryFloatingPoint {
    let lineWidth: CGFloat
    let state: State
    let fraction: ClosedRange<State.RawValue>
    let color: (State) -> Color
    let content: (State) -> Content
    
    /// Creates a `CircularProgress` with inner content and color provided in initializer.
    /// The most generic initializer which simplifies creation of custom styles and gives much freedom to client code.
    ///
    /// - Parameters:
    ///   - lineWidth: Width of the progress circle and exclamation or checkmark in case of `.progressStyle(.interactive)`.
    ///   - state: Initial state of the circular progress.
    ///   - fraction: Size of the loader indicator. In order to display the progress it usuallly depend on the progress state.
    ///   - color: Closure that provides progress circle color based on the state.
    ///   - content: Content that will be layouted inside of the progress circle based on the state. For example `.progressStyle(.interactive)` adds checkmark and exclamtion for `.succeeded/.failed` states.
    ///
    /// - Example:
    ///  ```
    /// CircularProgress(
    ///     lineWidth: 20,
    ///     state: 0.0,
    ///     fraction:
    ///     color: { _ in .accentColor },
    ///     content: { _ in Text("Inner") }
    /// )
    ///  ```
    public init(
        lineWidth: CGFloat,
        state: State,
        fraction: ClosedRange<State.RawValue>,
        color: @escaping (State) -> Color,
        @ViewBuilder _ content: @escaping (State) -> Content
    ) {
        self.lineWidth = lineWidth
        self.state = state
        self.fraction = fraction
        self.color = color
        self.content = content
    }
    
    /// Creates a `CircularProgress` with inner content and color provided in initializer.
    /// The most generic initializer which simplifies creation of custom styles and gives much freedom to client code.
    ///
    /// - Parameters:
    ///   - lineWidth: Width of the progress circle and exclamation or checkmark in case of `.progressStyle(.interactive)`.
    ///   - state: Initial state of the circular progress.
    ///   - color: Closure that provides progress circle color based on the state.
    ///   - content: Content that will be layouted inside of the progress circle based on the state. For example `.progressStyle(.interactive)` adds checkmark and exclamtion for `.succeeded/.failed` states.
    ///
    /// - Example:
    ///  ```
    /// CircularProgress(
    ///     lineWidth: 20,
    ///     state: 0.0
    ///     color: { _ in .accentColor },
    ///     content: { _ in Text("Inner") }
    /// )
    ///  ```
    public init(
        lineWidth: CGFloat,
        state: State,
        color: @escaping (State) -> Color,
        @ViewBuilder _ content: @escaping (State) -> Content
    ) {
        self.init(
            lineWidth: lineWidth,
            state: state,
            fraction: (0...state.rawValue),
            color: color,
            content
        )
    }
    
    /// Creates a `CircularProgress` without any inner content and with color provided in initializer.
    ///
    /// - Parameters:
    ///   - lineWidth: Width of the progress circle and exclamation or checkmark in case of `.progressStyle(.interactive)`.
    ///   - state: Initial state of the circular progress.
    ///   - fraction: Size of the loader indicator. In order to display the progress it usuallly depend on the progress state.
    ///   - color: Closure that provides progress circle color based on the state.
    /// - Example:
    ///  ```
    /// CircularProgress(
    ///     lineWidth: 20,
    ///     state: 0.0
    ///     color: { _ in .accentColor }
    /// )
    ///  ```
    public init(
        lineWidth: CGFloat,
        state: State,
        fraction: ClosedRange<State.RawValue>,
        color: @escaping (State) -> Color
    ) where Content == EmptyView {
        self.init(
            lineWidth: lineWidth,
            state: state,
            fraction: fraction,
            color: color,
            { _ in EmptyView() }
        )
    }
    
    
    /// Creates a `CircularProgress` without any inner content and with color provided in initializer.
    ///
    /// - Parameters:
    ///   - lineWidth: Width of the progress circle and exclamation or checkmark in case of `.progressStyle(.interactive)`.
    ///   - state: Initial state of the circular progress.
    ///   - color: Closure that provides progress circle color based on the state.
    /// - Example:
    ///  ```
    /// CircularProgress(
    ///     lineWidth: 20,
    ///     state: 0.0
    ///     color: { _ in .accentColor }
    /// )
    ///  ```
    public init(
        lineWidth: CGFloat,
        state: State,
        color: @escaping (State) -> Color
    ) where Content == EmptyView {
        self.init(
            lineWidth: lineWidth,
            state: state,
            fraction: 0...state.rawValue,
            color: { _ in .accentColor },
            { _ in EmptyView() }
        )
    }
    
    /// Creates a `CircularProgress` without any inner content and with color provided in initializer.
    ///
    /// - Parameters:
    ///   - lineWidth: Width of the progress circle and exclamation or checkmark in case of `.progressStyle(.interactive)`.
    ///   - state: Initial state of the circular progress.
    ///   - fraction: Size of the loader indicator. In order to display the progress it usuallly depend on the progress state.
    /// - Example:
    ///  ```
    /// CircularProgress(
    ///     lineWidth: 20,
    ///     state: 0.0
    ///     color: { _ in .accentColor }
    /// )
    ///  ```
    public init(
        lineWidth: CGFloat,
        state: State,
        fraction: @autoclosure () -> ClosedRange<State.RawValue>
    ) where Content == EmptyView {
        self.init(
            lineWidth: lineWidth,
            state: state,
            fraction: fraction(),
            color: { _ in .accentColor },
            { _ in EmptyView() }
        )
    }

    
    /// Creates a `CircularProgress` without any inner content and with `.accentColor` color of the progress circle.
    /// Color of the circle can be changed usint `.tint(_ color:)` or `.accentColor(_ color:)` based on the OS version.
    ///
    /// - Parameters:
    ///   - lineWidth:Width of the progress circle and exclamation or checkmark in case of `.progressStyle(.interactive)`.
    ///   - state: Initial state of the circular progress.
    /// - Example:
    ///  ```
    /// CircularProgress(
    ///     lineWidth: 20,
    ///     state: 0.0
    /// )
    ///  ```
    public init(
        lineWidth: CGFloat,
        state: State
    ) where Content == EmptyView {
        self.init(
            lineWidth: lineWidth,
            state: state,
            fraction: 0...state.rawValue,
            color: { _ in .accentColor },
            { _ in EmptyView() }
        )
    }
    
    public var body: some View {
        GeometryReader { proxy in
                ZStack {
                    Circle()
                        .stroke(color(state).opacity(0.5), lineWidth: lineWidth)
                        .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    
                    Circle()
                        .trim(from: CGFloat(fraction.lowerBound), to: CGFloat(fraction.upperBound))
                        .stroke(color(state), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    
                    
                    content(state)
                        .frame(square: sqrt(pow(min(proxy.size.height, proxy.size.width) - lineWidth, 2) / 2))
                        .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                }
                .frame(maxWidth: proxy.size.width - lineWidth, maxHeight: proxy.size.height - lineWidth)
        }
    }
}

/// Helper modifier to simplify frame definitions.
extension View {
    @warn_unqualified_access
    @inlinable
    func frame(square: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: square, height: square, alignment: alignment)
    }
}

/// Allows to use plain `Double`  as `State` in `CircularProgress`
extension Double: RawRepresentable {
    public var rawValue: Double { self }
    
    public init?(rawValue: Double) { self = rawValue }
}

/// Allows to use plain `Float` as `State` in `CircularProgress`
extension Float: RawRepresentable {
    public var rawValue: Float { self }
    
    public init?(rawValue: Float) { self = rawValue }
}

/// Allows to use plain `CGFloat` as `State` in `CircularProgress`
extension CGFloat: RawRepresentable {
    public var rawValue: CGFloat { self }
    
    public init?(rawValue: CGFloat) { self = rawValue }
}

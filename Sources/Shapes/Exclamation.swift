import SwiftUI

/// Exclamation shape to show inside the `CircularProgress`.
/// Path approach used to allow for pretty animation using `.trim(from:, to:)`
public struct ExclamationShape: Shape {
    let lineWidth: CGFloat
    let lineHeightFraction: CGFloat
    
    /// Allows to create exclamation mark shape and tweak the exclamation line relative size to adapt it for extra small and extra large frames.
    ///
    /// - Parameters:
    ///   - lineWidth: Line width of the circle.
    ///   - lineHeightFraction: Fraction of the whole rectangle height which will be occupied by the exclamation line.
    ///
    public init(
        lineWidth: CGFloat,
        lineHeightFraction: CGFloat = 0.68
    ) {
        self.lineWidth = lineWidth
        self.lineHeightFraction = lineHeightFraction
    }
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.width / 2, y: lineWidth / 2))
            path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height * lineHeightFraction))
            
            path.move(to: CGPoint(x: rect.width / 2, y: rect.height - lineWidth / 2))
            path.addLine(to: CGPoint(x: rect.width / 2 , y: rect.height - lineWidth / 2))
        }
    }
}

/// View wrapper for `ExclamationShape` with desired animation on `Path`
public struct ExclamationView: View {
    @State
    private var progress: CGFloat = 0
    
    let shape: ExclamationShape
    
    public init(lineWidth: CGFloat) {
        self.shape = ExclamationShape(lineWidth: lineWidth)
    }
    
    public init(shape: ExclamationShape) {
        self.shape = shape
    }
    
    public var body: some View {
        shape
            .trim(from: 0, to: progress)
            .stroke(style: StrokeStyle(lineWidth: shape.lineWidth, lineCap: .round, lineJoin: .round))
            .onAppear { withAnimation { progress += 1 } }
    }
}

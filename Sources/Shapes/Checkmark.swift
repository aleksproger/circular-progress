import SwiftUI

/// Checkmark shape to show inside the `CircularProgress`.
/// Path approach used to allow for pretty animation using `.trim(from:, to:)`
public struct CheckmarkShape: Shape {
    let lineWidth: CGFloat
    let leftLineRelativeToDiameter: CGFloat
    let rightLineRelativeToDiameter: CGFloat
    
    /// Allows to create checkmark shape and tweak the lines relative sizes to adapt it for extra small and extra large frames.
    ///
    /// - Parameters:
    ///   - lineWidth: Line width of the circle.
    ///   - leftLineRelativeToDiameter: Relative size of the left line to the diameter of the enclosing circle.
    ///   - rightLineRelativeToDiameter: Relative size of the right line to the diameter of the  enclosing circle.
    ///
    public init(
        lineWidth: CGFloat,
        leftLineRelativeToDiameter: CGFloat = 0.56,
        rightLineRelativeToDiameter: CGFloat = 0.82
    ) {
        self.lineWidth = lineWidth
        self.leftLineRelativeToDiameter = leftLineRelativeToDiameter
        self.rightLineRelativeToDiameter = rightLineRelativeToDiameter
    }
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: lineWidth / 2, y: rect.height * (1 - leftLineRelativeToDiameter) + lineWidth / 2))
            path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - lineWidth / 2))
            path.addLine(to: CGPoint(x: rect.width - lineWidth / 2, y: rect.height * (1 - rightLineRelativeToDiameter) + lineWidth / 2))
        }
    }
}

/// View wrapper for `CheckmarkShape` with desired animation on `Path`
public struct CheckmarkView: View {
    @State
    private var progress: CGFloat = 0
    
    let shape: CheckmarkShape
    
    public init(lineWidth: CGFloat) {
        self.shape = CheckmarkShape(lineWidth: lineWidth)
    }
    
    public init(shape: CheckmarkShape) {
        self.shape = shape
    }
    
    public var body: some View {
        shape
            .trim(from: 0, to: progress)
            .stroke(style: StrokeStyle(lineWidth: shape.lineWidth, lineCap: .round, lineJoin: .round))
            .onAppear { withAnimation { progress += 1 } }
    }
}

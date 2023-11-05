/// Defines 3 default states and is used in `InteractiveCircularProgressStyle`.
/// Can be used to define custom `CircularProgressStyle` styles.
public enum CircularProgressState: Equatable {
    case inProgress(Double)
    case failed
    case succeeded
}

/// `State` that intended to be used in `CircularProgress` must expose progress fraction through `rawValue`.
extension CircularProgressState: RawRepresentable {
    public var rawValue: Double {
        switch self {
        case let .inProgress(progress): progress
        case .failed, .succeeded: 1.0 }
    }
    
    public init?(rawValue: Double) {
        self = .inProgress(rawValue)
    }
}

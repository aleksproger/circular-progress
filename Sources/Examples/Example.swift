import SwiftUI

@available(macOS 12.0, *)
struct ExamplePreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                SimpleExampleView(lineWidth: 10)
                    .frame(square: 100)
                
                RotatingExampleView(lineWidth: 10)
                    .accentColor(.purple)
                    .frame(square: 100)
            }
            
            HStack {
                InteractiveExampleView(lineWidth: 10)
                    .frame(square: 100)
                
                CustomExampleView(lineWidth: 10)
                    .frame(square: 100)
            }
            
            InteractiveExampleView(lineWidth: 2)
                .frame(square: 20)
        }
        .padding()
    }
}

// MARK: - Predefined .simple style with CircularProgressState

/// Example of view which uses the predefined `.progressStyle(.simple)` style, which uses `Double` as state type.
/// States: blue loader for all states, doesn't show anything on succeess or failure.
struct SimpleExampleView: View {
    @State
    var progress: Double = 0
    let lineWidth: CGFloat
    
    var body: some View {
        CircularProgress(lineWidth: lineWidth, state: progress)
            .progressStyle(.simple)
            .onTimer(1) { progress += 0.25 }
    }
}

struct RotatingExampleView: View {
    @State
    var progress: Double = 0
    let lineWidth: CGFloat
    
    var body: some View {
        CircularProgress(lineWidth: lineWidth, state: progress)
            .progressStyle(.rotating)
            .onTimer(1) { progress += 0.25 }
    }
}

// MARK: - Predefined .interactive style with CircularProgressState

/// Example of view which uses the predefined `.progressStyle(.interactive)` style, which uses `CircularProgressState`.
/// States: blue loader for `.inProgress()`, green checkmark for `.succeeded` and  red exclamation mark for `.failed.
/// - Warning: Be careful with combination of `CircularProgress` frame and `lineWidth` to be sure that exclamation or checkmark look correctly.
struct InteractiveExampleView: View {
    @State
    var progress = CircularProgressState.inProgress(0)
    let lineWidth: CGFloat
    
    var body: some View {
        CircularProgress(lineWidth: lineWidth, state: progress)
            .progressStyle(.interactive)
            .onTimer {
                progress = if progress.rawValue + 0.34 >= 1 { Bool.random() ? .succeeded : .failed }
                else { .inProgress(progress.rawValue + 0.34) }
            }
    }
}


// MARK: - Custom CircularProgress style with custom state

struct CustomExampleView: View {
    @State
    var progress: CustomState = .inProgress(0)
    let lineWidth: CGFloat
    
    var body: some View {
        CircularProgress(lineWidth: lineWidth, state: progress)
            .progressStyle(.custom)
            .onTimer(0.5) {
                progress = if progress.rawValue + 0.34 >= 1 { .finished }
                else { .inProgress(progress.rawValue + 0.34) }
            }
    }
}

/// Custom state that may represent any number of states of the loader.
enum CustomState {
    case inProgress(Double)
    case finished
}

/// `RawRepresentable` thath allows to retrieve fraction of progress through `rawValue: Double`.
extension CustomState: RawRepresentable {
    public var rawValue: Double {
        switch self {
        case let .inProgress(progress): progress
        case .finished: 1.0 }
    }
    
    public init?(rawValue: Double) {
        self = .inProgress(rawValue)
    }
}

/// Style that constructs `CircularProgress` view according to the `CustomState` declared by the client.
/// Allows to configure with maximum flexibility, while preserving `CircualrProgress` sematics in the declaration site. Similar to Apple styling approach.
struct CustomCircularProgressStyle: CircularProgressStyle {
    func makeBody(configuration: CircularProgressStyleConfiguration<CustomState>) -> some View {
        CircularProgress(
            lineWidth: configuration.lineWidth,
            state: configuration.state,
            color: { state in
                switch state {
                case .finished: .pink
                case .inProgress: .green }
            }
        ) { state in
            switch state {
            case .finished: Text("🎉").font(.largeTitle).bold()
            case .inProgress: Text(String("\(state.rawValue * 100)")) }
            
        }
    }
}

/// Adds ability to use `CustomCircularProgressStyle` using modifier `.progressStyle(_ style: CircularProgressStyle)` on `CircularProgress` view.
extension CircularProgressStyle where Self == CustomCircularProgressStyle {
    static var custom: CustomCircularProgressStyle { CustomCircularProgressStyle() }
}

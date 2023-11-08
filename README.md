# CircularProgress

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Faleksproger%2Fcircular-progress%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/aleksproger/circular-progress)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Faleksproger%2Fcircular-progress%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/aleksproger/circular-progress)

## Simple and flexible circular progress view in SwiftUI 

CircularProgress is small and flexible implementation of circular progress view in SwiftUI. 
It allows to add pretty and customizable circular progress loaders into your application .

## Highlights

* **Simple** just add `CircularProgress()` to your view hierarchy and you will get smooth and animatable progress view.
* **Flexible** implementation allow to define custom style and and content inside the circle. 
* **Lightwheight** the package is small and won't introduce any overheds to SPM resolve process, no 3rd party dependencies.

## Usage

#### Circular progress with default style

```swift
struct SimpleExampleView: View {
    @State
    var progress: Double = 0
    let lineWidth: CGFloat
    
    var body: some View {
        CircularProgress(lineWidth: lineWidth, state: progress)
            .onTimer { progress += 0.34 }
    }
}
```

#### Circular progress with interactive style

```swift
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
```

#### Circular progress with rotating style

```swift
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
```

#### Circular progress with custom style

```swift
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

enum CustomState {
    case inProgress(Double)
    case finished
}

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

struct CustomCircularProgressStyle: CircularProgressStyle {
    func makeBody(configuration: CircularProgressStyleConfiguration<CustomState>) -> some View {
        CircularProgress(
            lineWidth: configuration.lineWidth,
            state: configuration.state,
            color: { state in
                switch state {
                case .finished: .pink
                case .inProgress: .white }
            }
        ) { state in
            switch state {
            case .finished: Text("🎉").font(.largeTitle).bold()
            case .inProgress: Text(String("\(state.rawValue * 100)")) }
            
        }
    }
}

extension CircularProgressStyle where Self == CustomCircularProgressStyle {
    static var custom: CustomCircularProgressStyle { CustomCircularProgressStyle() }
}
```

#### Illustration of examples from Sources/Examples
https://github.com/aleksproger/circular-progress/assets/45671572/a27a3523-619a-4cb8-b88e-253e6360b706


## Requirements

* iOS 14.0+
* macOS 11.0+
* watchOS 7.0+
* tvOS 14.0+

## Installation

**SwiftPM**

```swift
.package(url: "https://github.com/aleksproger/circular-progress.git", .upToNextMajor(from: "1.1.0"))
```

**Bazel**

```python
git_repository(
    name = "circular-progress",
    branch = "1.1.0",
    remote = "https://github.com/aleksproger/circular-progress.git",
    repo_mapping = {},
)
```

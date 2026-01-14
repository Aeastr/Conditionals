<div align="center">
  <img width="128" height="128" src="/Resources/icon.png" alt="Conditionals Icon">
  <h1><b>Conditionals</b></h1>
  <p>
    Clean, composable conditional modifier APIs for SwiftUI OS availability checks.
  </p>
</div>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/iOS-16+-000000?logo=apple" alt="iOS 16+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/macOS-13+-000000?logo=apple" alt="macOS 13+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/tvOS-16+-000000?logo=apple" alt="tvOS 16+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/watchOS-9+-000000?logo=apple" alt="watchOS 9+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/visionOS-1+-000000?logo=apple" alt="visionOS 1+"></a>
</p>


## Overview

- **Fluent API** for OS version-gated modifiers instead of nested `#available` checks
- **View, ToolbarContent, and ToolbarItemPlacement** extensions out of the box
- **Generic `conditional()` functions** for any type
- **`Conditional` protocol** to add conditional support to custom types
- **`OSVersion` helpers** for clean version checks (`OSVersion.iOS(17)`)

> **Important:** Conditionals is for **static conditions** (OS versions, compile-time checks). For runtime state that changes, use standard SwiftUI patterns (`if`, ternary, `overlay`). See [When to Use](docs/WhenToUse.md) for guidance.

```swift
// GOOD - OS version never changes at runtime
.conditional(if: OSVersion.iOS(17)) { view in view.fontDesign(.rounded) }

// BAD - use .foregroundStyle(isActive ? .blue : .gray) instead
.conditional(if: isActive) { view in view.foregroundStyle(.blue) }
```


## Installation

```swift
dependencies: [
    .package(url: "https://github.com/aeastr/Conditionals.git", from: "1.0.0")
]
```

```swift
import Conditionals
```


## Usage

### OS Version Checks

Apply modifiers based on OS version availability:

```swift
Text("Modern UI")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
    }
```

### Simple Conditions

```swift
Text("Hello")
    .conditional(if: OSVersion.iOS(17)) { view in
        view.fontDesign(.rounded)
    }
```

### Optional Unwrapping

```swift
Text("Hello")
    .conditional(if: optionalColor) { view, color in
        view.foregroundStyle(color)
    }
```

### Toolbar Placement

```swift
ToolbarItemGroup(
    placement: .conditional(
        if: OSVersion.iOS(26),
        then: .bottomBar,
        else: .secondaryAction
    )
) {
    Button("Edit") {}
}
```

### With Fallback

```swift
Text("Hello")
    .conditional(
        if: OSVersion.iOS(26),
        apply: { $0.fontWeight(.bold) },
        otherwise: { $0.fontWeight(.regular) }
    )
```

### Unless (Negated)

```swift
Text("Content")
    .conditional(unless: isCompact) { view in
        view.padding(.horizontal, 40)
    }
```

### Generic Functions

For inline value selection:

```swift
Text("Hello")
    .foregroundStyle(
        conditional(if: OSVersion.iOS(17), then: Color.red.gradient, else: Color.red)
    )
```

### Any Type via Protocol

Add conditional support to any type with one line:

```swift
extension PresentationDetent: Conditional {}

// Now use it
.presentationDetents([
    .conditional(if: OSVersion.iOS(16), then: .height(300), else: .medium)
])
```


## Customization

### OS Version Helpers

```swift
OSVersion.iOS(18)       // Check iOS 18+
OSVersion.macOS(14)     // Check macOS 14+
OSVersion.watchOS(10)   // Check watchOS 10+
OSVersion.tvOS(17)      // Check tvOS 17+

OS.is26                 // Quick boolean check for iOS 26+
```


## How It Works

Conditionals wraps the standard `#available` pattern in a chainable API using `@ViewBuilder` closures:

```swift
// Before: Verbose, breaks the chain
Group {
    if #available(iOS 26.0, *) {
        Text("Hello").glassEffect(.regular, in: .rect(cornerRadius: 12))
    } else {
        Text("Hello").background(.regularMaterial, in: .rect(cornerRadius: 12))
    }
}

// After: Clean and chainable
Text("Hello")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
    }
```

> For iOS 26's glass effects specifically, check out [UniversalGlass](https://github.com/Aeastr/UniversalGlass).


## Contributing

Contributions welcome. See the [Contributing Guide](CONTRIBUTING.md) for details.


## License

MIT. See [LICENSE](LICENSE) for details.

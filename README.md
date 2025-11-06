<div align="center">
  <img width="200" height="200" src="/Resources/icon.png" alt="Conditionals Logo">
  <h1><b>Conditionals</b></h1>
  <p>
    A lightweight SwiftUI package that provides clean, composable conditional modifier APIs for handling OS availability checks.
  </p>
</div>

<p align="center">
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-16%2B-blue.svg" alt="iOS 16+"></a>
  <a href="https://developer.apple.com/visionos/"><img src="https://img.shields.io/badge/visionOS-1%2B-purple.svg" alt="visionOS 1+"></a>
  <a href="https://developer.apple.com/macos/"><img src="https://img.shields.io/badge/macOS-13%2B-blue.svg" alt="macOS 13+"></a>
  <a href="https://developer.apple.com/watchos/"><img src="https://img.shields.io/badge/watchOS-9%2B-blue.svg" alt="watchOS 9+"></a>
  <a href="https://developer.apple.com/tvos/"><img src="https://img.shields.io/badge/tvOS-16%2B-blue.svg" alt="tvOS 16+"></a>
  <a href="https://swift.org/"><img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT"></a>
</p>

---

> **Important:** This package is designed primarily for **static conditions** (OS versions, compile-time checks). Using conditionals with **runtime state** that changes frequently can cause view identity loss and state resets. See the [View Identity & Performance](#️-important-view-identity--performance) section for details.

## Purpose

Conditionals simplifies applying SwiftUI modifiers based on:
- **OS version availability** (primary use case)
- **Compile-time `#available` checks**
- **Static styling** modifiers that don't change at runtime

Instead of cluttering your views with nested `#available` checks, Conditionals provides a fluent, chainable API that keeps your code clean and readable.

**Best suited for:** OS version checks, compile-time features, static configuration.
**Not recommended for:** Runtime state, collections, toggleable properties (use `if`/`overlay`/`background` instead).

## When to Use Conditionals vs `#if` Directives

### Use Standard Swift Compiler Directives (`#if os()`)

For **platform-specific APIs** that simply don't exist on certain platforms, use Swift's built-in compiler directives directly:

```swift
// ✅ Use #if os() - navigationBarTitleDisplayMode is iOS-only
NavigationStack {
    ContentView()
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
}
```

**Why not Conditionals?** The API doesn't exist on macOS at all—it's not a version issue, it's a platform issue. Standard `#if` directives handle this cleanly at compile time.

### Use Conditionals for OS Version Checks

Use Conditionals when you need to check **OS versions** for features that were introduced in specific releases:

```swift
// ✅ Use Conditionals - glassEffect requires iOS 26.0+
Text("Card")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
    }
```

**Why Conditionals?** The API exists across platforms but requires a minimum OS version. Conditionals provides a clean, chainable API for these version-gated features.

### Quick Reference

| Scenario | Use | Example |
|----------|-----|---------|
| Platform-specific API | `#if os(iOS)` | `.navigationBarTitleDisplayMode()` (iOS only) |
| Version-gated feature | Conditionals | `.glassEffect()` (iOS 26.0+) |
| Platform + version | Both | `#if os(iOS)` with `if #available(iOS 26.0, *)` |

## Installation

### Swift Package Manager

Add Conditionals to your project via Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL
3. Select version/branch

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/aeastr/Conditionals.git", from: "1.0.0")
]
```

### Platform Support

- iOS 16.0+
- visionOS 1.0+
- macOS 13.0+
- watchOS 9.0+
- tvOS 16.0+

## API Overview

### View Extensions

#### `conditional(if:apply:)`
Apply a modifier only when a condition is true.

```swift
Text("Hello")
    .conditional(if: OSVersion.iOS(26)) { view in
        view.fontDesign(.rounded)
    }
```

#### `conditional(if:apply:otherwise:)`
Apply one modifier when true, another when false.

```swift
Text("Adaptive")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
    }
```

#### `conditional(apply:)`
Full control over availability checks within the closure.

```swift
Text("Custom Check")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else if #available(iOS 18.0, *) {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        } else {
            view.background(Color.gray.opacity(0.3))
        }
    }
```

#### `conditional(if:apply:)` - Optional Unwrapping
Apply a modifier when an optional value is non-nil, with the unwrapped value available.

```swift
Text("Hello")
    .conditional(if: optionalColor) { view, color in
        view.foregroundStyle(color)
    }
```

#### `conditional(unless:apply:)`
Apply a modifier only when a condition is false. More readable than `if: !condition`.

```swift
Text("Content")
    .conditional(unless: isCompact) { view in
        view.padding(.horizontal, 40)
    }
```

### ToolbarContent Extensions

All `View` conditional methods are available for `ToolbarContent` as well:

1. `.conditional(if:apply:)` - Basic conditional
2. `.conditional(if:apply:otherwise:)` - With fallback
3. `.conditional(apply:)` - Closure variant
4. `.conditional(if:apply:)` - Optional unwrapping
5. `.conditional(unless:apply:)` - Negated variant

```swift
ToolbarItem(placement: .topBarTrailing) {
    Button("Action") {}
        .conditional(if: OSVersion.iOS(26)) { view in
            view.tint(.blue)
        }
}
```

### ToolbarItemPlacement Extensions

Choose toolbar item placement conditionally using the `Conditional` protocol.

#### `conditional(if:then:else:)`
Select placement based on a boolean condition.

```swift
ToolbarItemGroup(
    placement: .conditional(
        if: OSVersion.iOS(26),
        then: .bottomBar,
        else: .secondaryAction
    )
) {
    Button("Edit") {}
    Button("Share") {}
}
```

#### `conditional(_:)`
Full control with closure for complex availability checks.

```swift
ToolbarItemGroup(
    placement: .conditional {
        #if os(iOS)
        if #available(iOS 26.0, *) {
            .bottomBar
        } else {
            .secondaryAction
        }
        #else
        .automatic
        #endif
    }
) {
    Button("Edit") {}
}
```

#### `conditional(unless:then:else:)`
Select placement based on a negated condition.

```swift
ToolbarItemGroup(
    placement: .conditional(
        unless: isCompact,
        then: .principal,
        else: .automatic
    )
) {
    Text("Title")
}
```

### Generic Conditional Functions

For types that don't have specific extensions, use the generic `conditional()` functions:

#### `conditional(if:then:else:)`
Select any value conditionally.

```swift
let color = conditional(
    if: isDarkMode,
    then: Color.white,
    else: Color.black
)

Text("Hello")
    .foregroundStyle(
        conditional(
            if: OSVersion.iOS(17),
            then: Color.red.gradient,
            else: Color.red
        )
    )
```

#### `conditional(_:)`
Full control for `#available` checks with any type.

```swift
.presentationDetents([
    conditional {
        if #available(iOS 16.0, *) {
            PresentationDetent.height(300)
        } else {
            .medium
        }
    }
])
```

#### `conditional(unless:then:else:)`
Select values based on a negated condition.

```swift
let padding = conditional(
    unless: isCompact,
    then: 40.0,
    else: 16.0
)
```

#### `conditional(if:transform:else:)`
Transform optional values or provide fallback.

```swift
let spacing = conditional(
    if: customSpacing,
    transform: { $0 * 2 },
    else: 16.0
)
```

### Making Any Type Conditional

You can make **any type** work with `.conditional()` syntax by conforming to the `Conditional` protocol. It's as simple as one line:

```swift
extension PresentationDetent: Conditional {}
```

That's it! No implementation needed. Now you get all conditional methods for free:

```swift
// Value selection with dot syntax
.presentationDetents([
    .conditional(
        if: OSVersion.iOS(16),
        then: .height(300),
        else: .medium
    )
])

// Or with #available checks
.presentationDetents([
    .conditional {
        if #available(iOS 16.0, *) {
            .height(300)
        } else {
            .medium
        }
    }
])

// Or with unless variant
.presentationDetents([
    .conditional(
        unless: isCompact,
        then: .large,
        else: .medium
    )
])
```

#### More Examples

```swift
// Make ScrollBounceBehavior conditional
extension ScrollBounceBehavior: Conditional {}

ScrollView {
    content
}
.scrollBounceBehavior(
    .conditional(
        if: OSVersion.iOS(18),
        then: .basedOnSize,
        else: .always
    )
)

// Make any custom type conditional
extension MyCustomPlacement: Conditional {}

myView.customModifier(
    placement: .conditional(
        if: someCondition,
        then: .leading,
        else: .trailing
    )
)
```

The protocol provides both static value selection methods and instance transformation methods, so conforming types get the full conditional API automatically.

### OS Version Helpers

#### `OSVersion` enum
Check specific OS versions at runtime.

```swift
OSVersion.iOS(18)       // Check iOS 18+
OSVersion.macOS(14)     // Check macOS 14+
OSVersion.watchOS(10)   // Check watchOS 10+
OSVersion.tvOS(17)      // Check tvOS 17+

OSVersion.supportsGlassEffect  // Convenience: iOS 26+
```

#### `OS` enum
Quick boolean checks for specific versions.

```swift
OS.is26  // true if iOS 26+

let style = OS.is26 ? .glass : .regular
```


## Usage Examples

### Basic Conditional

```swift
Text("Hello")
    .conditional(if: someCondition) { view in
        view.padding(20)
    }
```

### OS Version-Specific Features

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

### Gated Compiler Features

For features that require compile-time availability (like iOS 26's glass effects), use the closure variant:

```swift
Text("Glass Effect")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 16))
        } else {
            view.background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
        }
    }
```

> **💡 Note:** If you're specifically working with iOS 26's glass effects and want a dedicated solution, check out [UniversalGlass](https://github.com/Aeastr/UniversalGlass). It brings SwiftUI's iOS 26 glass APIs to earlier deployments with lightweight shims—keeping your UI consistent on iOS 18+, while automatically deferring to real implementations wherever they exist. UniversalGlass uses Conditionals under the hood but is purpose-built for glass effects.


### Primary/Fallback Pattern

```swift
Text("Adaptive Card")
    .padding()
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
    }
```

### Platform-Specific Code

```swift
Text("Cross-Platform")
    .conditional { view in
        #if os(iOS)
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else if #available(iOS 18.0, *) {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        } else {
            view.background(Color.gray.opacity(0.3))
        }
        #elseif os(macOS)
        view.background(Color(.windowBackgroundColor))
        #else
        view
        #endif
    }
```

### Toolbar Conditionals

```swift
NavigationStack {
    ContentView()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Action") {}
                    .conditional(if: OSVersion.iOS(26)) { view in
                        view.tint(.blue)
                    }
            }
        }
}
```

### Using `unless` for Better Readability

```swift
struct ContentView: View {
    let isCompact: Bool

    var body: some View {
        Text("Article")
            .conditional(unless: isCompact) { view in
                view
                    .frame(maxWidth: 600)
                    .padding(.horizontal, 40)
            }
    }
}
```

### Platform-Specific Code

For platform-specific code, use Swift's built-in `#if os()` compiler directives:

```swift
Text("Cross-Platform")
    .conditional { view in
        #if os(iOS)
        view.padding()
            .background(.blue.opacity(0.2))
        #elseif os(macOS)
        view.padding()
            .background(.green.opacity(0.2))
        #else
        view
        #endif
    }
```

## ⚠️ Important: View Identity & Performance

### Understanding View Identity Loss

When you conditional wrap an entire view based on runtime state that can change, SwiftUI sees it as a **completely different view** when the condition toggles. This causes:

- ❌ **Full view reconstruction** - SwiftUI tears down and rebuilds the entire view hierarchy
- ❌ **Lost state** - any `@State` inside gets reset
- ❌ **Broken animations** - transitions get interrupted
- ❌ **Performance hit** - unnecessary layout passes

### The Problem

#### ❌ BAD: View Identity Changes

```swift
struct BadExample: View {
    @State private var items: [String] = []
    @State private var counter = 0  // This will RESET!

    var body: some View {
        Text("Taps: \(counter)")
            .onTapGesture { counter += 1 }
            // ❌ BAD: When items changes from empty → non-empty,
            // SwiftUI sees this as a completely different view tree
            .conditional(if: !items.isEmpty) { view in
                view.badge(items.count)
            }
    }
}
```

**What happens:** When `items` goes from empty → non-empty (or vice versa), SwiftUI sees two completely different view types:
- **Empty state:** `Text` with no badge
- **Non-empty state:** `Text` with badge modifier

The view identity changes, so SwiftUI destroys the old view and creates a new one. Your `counter` state gets reset to 0.

#### ✅ GOOD: Preserve View Identity

```swift
struct GoodExample: View {
    @State private var items: [String] = []
    @State private var counter = 0  // This is PRESERVED!

    var body: some View {
        Text("Taps: \(counter)")
            .onTapGesture { counter += 1 }
            // ✅ GOOD: Use overlay - the Text maintains its identity
            .overlay(alignment: .topTrailing) {
                if !items.isEmpty {
                    Badge(count: items.count)
                }
            }
    }
}
```

**What happens:** The `Text` view always has the same identity. Only the overlay appears/disappears. SwiftUI's diffing algorithm can efficiently update just the overlay without touching the `Text` or its state.

### The Golden Rule

> **Conditionals should be inside view builders (`overlay`, `background`, `if` statements in `body`), not wrapping the view itself when the condition can change at runtime.**

### When to Use Conditionals Safely

#### ✅ SAFE: OS/Platform Checks (Compile-time or Static)

These conditions **never change at runtime**, so view identity is stable:

```swift
// ✅ Safe - OS version never changes at runtime
Text("Hello")
    .conditional(if: OSVersion.iOS(26)) { view in
        view.fontDesign(.rounded)
    }


// ✅ Safe - Styling modifiers don't affect view identity
Text("Content")
    .conditional(if: isDarkMode) { view in
        view.foregroundStyle(.white)
    }
```

#### ✅ SAFE: Styling Modifiers

Modifiers that only affect appearance, not structure:

```swift
// ✅ Colors, fonts, padding - all safe
Text("Title")
    .conditional(if: isHighlighted) { view in
        view
            .foregroundStyle(.blue)
            .fontWeight(.bold)
            .padding()
    }

// ✅ Effects are safe when the condition is for styling
Text("Card")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
    }
```

#### ❌ UNSAFE: Runtime State-Dependent Structure

Avoid wrapping views when the condition depends on app state that can change:

```swift
// ❌ BAD: Collection state can change
Text("Items")
    .conditional(if: !items.isEmpty) { view in
        view.badge(items.count)
    }

// ✅ GOOD: Use overlay instead
Text("Items")
    .overlay {
        if !items.isEmpty {
            Badge(count: items.count)
        }
    }

// ❌ BAD: Boolean state can toggle
Text("Status")
    .conditional(if: isActive) { view in
        view.background(.green)
    }

// ✅ GOOD: Put conditional inside background
Text("Status")
    .background {
        if isActive {
            Color.green
        }
    }
```

### Best Practices Summary

| Use Case | Safe? | Recommendation |
|----------|-------|----------------|
| OS version checks | ✅ Yes | Use conditionals - version never changes |
| Styling (colors, fonts) | ✅ Yes | Use conditionals - doesn't affect identity |
| Static padding/spacing | ✅ Yes | Use conditionals if condition is static |
| Platform detection | ⚠️ Maybe | Use `#if os(iOS)` instead - more idiomatic |
| Collection-based badges | ❌ No | Use `overlay { if !items.isEmpty { ... } }` |
| State-dependent structure | ❌ No | Use `if` statements in view body |
| Animated content | ❌ No | Keep conditionals inside view builders |
| Complex view hierarchies | ❌ No | Wrap individual modifiers, not whole trees |

### Quick Decision Guide

**Ask yourself:** "Can this condition change while the app is running?"

- **No** (OS version, platform, device type) → ✅ Safe to use conditionals
- **Yes** (app state, user preferences, collections) → ❌ Use `if`/`overlay`/`background` instead

## Why Conditionals?

Conditionals shines when you need to handle multiple OS versions. Compare the verbose before to the clean after:

### Before

```swift
Group {
    if #available(iOS 18.0, *) {
        Text("Hello")
            .fontWeight(.semibold)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
    } else {
        if #available(iOS 17.0, *) {
            Text("Hello")
                .fontWeight(.regular)
                .background(.regularMaterial, in: .rect(cornerRadius: 12))
        } else {
            Text("Hello")
                .fontWeight(.regular)
                .background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 12))
        }
    }
}
```

### After

```swift
Text("Hello")
    .conditional(if: OSVersion.iOS(26)) { view in
        view.fontWeight(.semibold)
    }
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else if #available(iOS 18.0, *) {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        } else {
            view.background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 12))
        }
    }
```

Clean, maintainable, and focused on what the package does best: **OS version checking**.

## License

MIT License - see LICENSE file for details.

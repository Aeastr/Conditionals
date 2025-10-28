<div align="center">
  <img width="200" height="200" src="/Resources/icon.png" alt="Conditionals Logo">
  <h1><b>Conditionals</b></h1>
  <p>
    A lightweight SwiftUI package that provides clean, composable conditional modifier APIs for handling OS availability checks.
  </p>
</div>

<p align="center">
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-16%2B-purple.svg" alt="iOS 16+"></a>
  <a href="https://developer.apple.com/macos/"><img src="https://img.shields.io/badge/macOS-13%2B-blue.svg" alt="macOS 13+"></a>
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
- macOS 13.0+
- watchOS 9.0+
- tvOS 16.0+

## API Overview

### View Extensions

#### `conditionally(if:apply:)`
Apply a modifier only when a condition is true.

```swift
Text("Hello")
    .conditionally(if: OSVersion.iOS(18)) { view in
        view.fontDesign(.rounded)
    }
```

#### `conditionally(if:apply:otherwise:)`
Apply one modifier when true, another when false.

```swift
Text("Adaptive")
    .conditionally(
        if: { OSVersion.iOS(18) },
        apply: { $0.background(.ultraThinMaterial) },
        otherwise: { $0.background(.gray.opacity(0.2)) }
    )
```

#### `conditionally(apply:)`
Full control over availability checks within the closure.

```swift
Text("Custom Check")
    .conditionally { view in
        if #available(iOS 17.0, *) {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        } else {
            view.background(Color.gray.opacity(0.3))
        }
    }
```

#### `conditionally(unless:apply:)`
Apply a modifier only when a condition is false. More readable than `if: !condition`.

```swift
Text("Content")
    .conditionally(unless: isCompact) { view in
        view.padding(.horizontal, 40)
    }

// More semantic than:
// .conditionally(if: !isCompact) { ... }
```

### ToolbarContent Extensions

All `View` conditional methods are available for `ToolbarContent` as well:

```swift
ToolbarItem(placement: .topBarTrailing) {
    Button("Action") {}
        .conditionally(if: OSVersion.iOS(16)) { view in
            view.tint(.blue)
        }
}
```

### ToolbarItemPlacement Extension

#### `conditional(modern:fallback:)`
Choose placement based on OS version.

```swift
ToolbarItemGroup(
    placement: .conditional(modern: .bottomBar, fallback: .secondaryAction)
) {
    Button("Edit") {}
    Button("Share") {}
}
```

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
    .conditionally(if: someCondition) { view in
        view.padding(20)
    }
```

### OS Version-Specific Features

```swift
Text("Modern UI")
    .conditionally(if: OSVersion.iOS(18)) { view in
        view
            .fontDesign(.rounded)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
    }
```

### Gated Compiler Features

For features that require compile-time availability (like iOS 26's glass effects), use the closure variant:

```swift
Text("Glass Effect")
    .conditionally { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 16))
        } else {
            view.background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
        }
    }
```


### Primary/Fallback Pattern

```swift
Text("Adaptive Card")
    .padding()
    .conditionally(
        if: { OSVersion.iOS(17) },
        apply: { view in
            view.background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
        },
        otherwise: { view in
            view.background(Color(.systemGray6), in: .rect(cornerRadius: 12))
        }
    )
```

### Platform-Specific Code

```swift
Text("Cross-Platform")
    .conditionally { view in
        #if os(iOS)
        if #available(iOS 17.0, *) {
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
                    .conditionally(if: OSVersion.iOS(16)) { view in
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
            .conditionally(unless: isCompact) { view in
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
    .conditionally { view in
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

When you conditionally wrap an entire view based on runtime state that can change, SwiftUI sees it as a **completely different view** when the condition toggles. This causes:

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
            .conditionally(if: !items.isEmpty) { view in
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
    .conditionally(if: OSVersion.iOS(18)) { view in
        view.fontDesign(.rounded)
    }


// ✅ Safe - Styling modifiers don't affect view identity
Text("Content")
    .conditionally(if: isDarkMode) { view in
        view.foregroundStyle(.white)
    }
```

#### ✅ SAFE: Styling Modifiers

Modifiers that only affect appearance, not structure:

```swift
// ✅ Colors, fonts, padding - all safe
Text("Title")
    .conditionally(if: isHighlighted) { view in
        view
            .foregroundStyle(.blue)
            .fontWeight(.bold)
            .padding()
    }

// ✅ Backgrounds are safe when the condition is for styling
Text("Card")
    .conditionally(if: OSVersion.iOS(17)) { view in
        view.background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
    }
```

#### ❌ UNSAFE: Runtime State-Dependent Structure

Avoid wrapping views when the condition depends on app state that can change:

```swift
// ❌ BAD: Collection state can change
Text("Items")
    .conditionally(if: !items.isEmpty) { view in
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
    .conditionally(if: isActive) { view in
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
    .conditionally(if: OSVersion.iOS(18)) { view in
        view.fontWeight(.semibold)
    }
    .conditionally { view in
        if #available(iOS 18.0, *) {
            view.background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
        } else if #available(iOS 17.0, *) {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        } else {
            view.background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 12))
        }
    }
```

Clean, maintainable, and focused on what the package does best: **OS version checking**.

## License

MIT License - see LICENSE file for details.

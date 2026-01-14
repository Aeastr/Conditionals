# Conditionals - View Identity & Performance

Understanding when to use Conditionals safely and when to use alternative patterns.

## Quick Start

**Ask: "Will this condition change while my app is running?"**

- **NO** (OS version, device type, platform) → Use Conditionals
- **YES** (state variables, user input, collections) → Use `if`/ternary/overlay

```swift
// GOOD - OS version is static
.conditional(if: OSVersion.iOS(17)) { view in
    view.fontDesign(.rounded)
}

// BAD - isActive changes at runtime
.conditional(if: isActive) { view in  // Don't do this!
    view.foregroundStyle(.blue)
}

// GOOD - Use ternary instead
.foregroundStyle(isActive ? .blue : .gray)
```

## Understanding View Identity Loss

When you conditionally wrap a view based on runtime state that changes, SwiftUI sees it as a **completely different view** when the condition toggles:

- Full view reconstruction - SwiftUI tears down and rebuilds the entire view hierarchy
- Lost state - any `@State` inside gets reset
- Broken animations - transitions get interrupted
- Performance hit - unnecessary layout passes

## The Problem

### BAD: View Identity Changes

```swift
struct BadExample: View {
    @State private var items: [String] = []
    @State private var counter = 0  // This will RESET!

    var body: some View {
        Text("Taps: \(counter)")
            .onTapGesture { counter += 1 }
            // BAD: When items changes from empty → non-empty,
            // SwiftUI sees this as a completely different view tree
            .conditional(if: !items.isEmpty) { view in
                view.badge(items.count)
            }
    }
}
```

**What happens:** When `items` goes from empty → non-empty, SwiftUI sees two different view types. The view identity changes, so SwiftUI destroys the old view and creates a new one. Your `counter` state gets reset to 0.

### GOOD: Preserve View Identity

```swift
struct GoodExample: View {
    @State private var items: [String] = []
    @State private var counter = 0  // This is PRESERVED!

    var body: some View {
        Text("Taps: \(counter)")
            .onTapGesture { counter += 1 }
            // GOOD: Use overlay - the Text maintains its identity
            .overlay(alignment: .topTrailing) {
                if !items.isEmpty {
                    Badge(count: items.count)
                }
            }
    }
}
```

**What happens:** The `Text` view always has the same identity. Only the overlay appears/disappears.

## The Golden Rule

> Conditionals should be inside view builders (`overlay`, `background`, `if` statements in `body`), not wrapping the view itself when the condition can change at runtime.

## Safe Use Cases

### OS/Platform Checks (Static)

These conditions never change at runtime:

```swift
// Safe - OS version never changes at runtime
Text("Hello")
    .conditional(if: OSVersion.iOS(26)) { view in
        view.fontDesign(.rounded)
    }
```

### Styling Modifiers

Modifiers that only affect appearance, not structure:

```swift
// Colors, fonts, padding - all safe
Text("Title")
    .conditional(if: isHighlighted) { view in
        view
            .foregroundStyle(.blue)
            .fontWeight(.bold)
            .padding()
    }

// Effects are safe for OS version checks
Text("Card")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
    }
```

## Unsafe Use Cases

### Runtime State-Dependent Structure

Avoid wrapping views when the condition depends on app state:

```swift
// BAD: Collection state can change
Text("Items")
    .conditional(if: !items.isEmpty) { view in
        view.badge(items.count)
    }

// GOOD: Use overlay instead
Text("Items")
    .overlay {
        if !items.isEmpty {
            Badge(count: items.count)
        }
    }

// BAD: Boolean state can toggle
Text("Status")
    .conditional(if: isActive) { view in
        view.background(.green)
    }

// GOOD: Put conditional inside background
Text("Status")
    .background {
        if isActive {
            Color.green
        }
    }
```

## Best Practices Summary

| Use Case | Safe? | Recommendation |
|----------|-------|----------------|
| OS version checks | Yes | Use conditionals - version never changes |
| Styling (colors, fonts) | Yes | Use conditionals - doesn't affect identity |
| Static padding/spacing | Yes | Use conditionals if condition is static |
| Platform detection | Maybe | Use `#if os(iOS)` instead - more idiomatic |
| Collection-based badges | No | Use `overlay { if !items.isEmpty { ... } }` |
| State-dependent structure | No | Use `if` statements in view body |
| Animated content | No | Keep conditionals inside view builders |
| Complex view hierarchies | No | Wrap individual modifiers, not whole trees |

## Notes

- Conditionals is designed for **compile-time or launch-time decisions**, not runtime state changes
- When in doubt, ask: "Can this condition change while the app is running?"
- For runtime conditions, prefer SwiftUI's built-in patterns: `if`, `overlay`, `background`, ternary operators

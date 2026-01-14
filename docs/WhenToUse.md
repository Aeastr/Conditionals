# Conditionals - When to Use

Guidance on when to use Conditionals vs standard Swift compiler directives.

## Quick Reference

| Scenario | Use | Example |
|----------|-----|---------|
| Platform-specific API | `#if os(iOS)` | `.navigationBarTitleDisplayMode()` (iOS only) |
| Version-gated feature | Conditionals | `.glassEffect()` (iOS 26.0+) |
| Platform + version | Both | `#if os(iOS)` with `if #available(iOS 26.0, *)` |

## Use `#if os()` Directives

For **platform-specific APIs** that don't exist on certain platforms:

```swift
// Use #if os() - navigationBarTitleDisplayMode is iOS-only
NavigationStack {
    ContentView()
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
}
```

**Why?** The API doesn't exist on macOS at all. It's not a version issue, it's a platform issue. Standard `#if` directives handle this at compile time.

## Use Conditionals

For **OS version checks** where features were introduced in specific releases:

```swift
// Use Conditionals - glassEffect requires iOS 26.0+
Text("Card")
    .conditional { view in
        if #available(iOS 26.0, *) {
            view.glassEffect(.regular, in: .rect(cornerRadius: 12))
        } else {
            view.background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
    }
```

**Why?** The API exists across platforms but requires a minimum OS version. Conditionals provides a clean, chainable API.

## Use Both

For platform-specific APIs that also have version requirements:

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

## Best Suited For

Conditionals shines with:

- **OS version availability** (primary use case)
- **Compile-time `#available` checks**
- **Static styling** modifiers that don't change at runtime

## Not Recommended For

Avoid Conditionals when the condition can change at runtime:

### Runtime State

```swift
// BAD - isActive can toggle
.conditional(if: isActive) { view in
    view.foregroundStyle(.blue)
}

// GOOD - use ternary
.foregroundStyle(isActive ? .blue : .gray)
```

### Collections

```swift
// BAD - items array changes
.conditional(if: !items.isEmpty) { view in
    view.badge(items.count)
}

// GOOD - use overlay
.overlay(alignment: .topTrailing) {
    if !items.isEmpty {
        Badge(count: items.count)
    }
}
```

### User Input / Toggles

```swift
// BAD - showDetails is user-controlled
.conditional(if: showDetails) { view in
    view.frame(height: 200)
}

// GOOD - use if in body or animation
if showDetails {
    DetailView()
        .frame(height: 200)
}
```

See [View Identity & Performance](ViewIdentity.md) for why runtime conditions cause problems.

## Why Conditionals?

Compare verbose nesting to clean chaining:

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

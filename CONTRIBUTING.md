# Contributing to Conditionals

Thanks for your interest in contributing! This package is focused on **OS version checking** and **compile-time conditionals** for SwiftUI.

## Guidelines

### What's Accepted

- ✅ Bug fixes for existing functionality
- ✅ Documentation improvements
- ✅ New OS version helpers (e.g., `OSVersion.supportsNewFeature`)
- ✅ Performance optimizations
- ✅ Additional compile-time conditional patterns

### What's Not Accepted

- ❌ Features that encourage runtime state conditionals (causes view identity loss)
- ❌ Optional unwrapping patterns that could be misused with `@State`
- ❌ Complex abstractions that hide the core OS version checking purpose
- ❌ Features that duplicate Swift's built-in `#if os()` functionality

## Core Principles

1. **OS version checking first** - This is the package's primary purpose
2. **Avoid view identity loss** - Don't add features that encourage wrapping views with runtime conditions
3. **Keep it simple** - The API should be clean and obvious
4. **DocC everything** - All public APIs need comprehensive documentation

## How to Contribute

1. **Open an issue first** to discuss your idea
2. **Fork and create a branch** for your changes
3. **Add tests** if applicable
4. **Update documentation** and examples
5. **Ensure no compiler warnings** (package supports iOS 16+)
6. **Submit a PR** with a clear description

## Code Style

- Follow Swift API Design Guidelines
- Use descriptive names that indicate OS/version focus
- Add DocC comments with examples
- Keep examples focused on OS version checking

## Questions?

Open an issue for discussion.

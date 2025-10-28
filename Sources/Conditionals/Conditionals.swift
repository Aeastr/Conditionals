//
//  Conditionals.swift
//  Conditionals
//
//  Created by Aether, 2025.
//
//  Copyright © 2025 Aether. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - View Extensions

/// A view extension that provides clean conditional modifier application based on OS availability.
public extension View {
    /// Conditionally applies a modifier only if the current OS version supports it.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines if the modifier should be applied.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - modifier: The modifier to apply when the condition is met
    /// - Returns: The view with the modifier applied conditionally
    ///
    /// The `@autoclosure` parameter allows clean syntax - you can write `OSVersion.supportsGlassEffect`
    /// instead of `{ OSVersion.supportsGlassEffect }`. The expression is automatically wrapped in a
    /// closure and only evaluated when needed, providing lazy evaluation.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .conditionally(if: someCondition) { view in
    ///         view.padding(.large)
    ///     }
    /// ```
    @ViewBuilder
    func conditionally<Content: View>(
        if condition: @autoclosure () -> Bool,
        @ViewBuilder apply modifier: (Self) -> Content
    ) -> some View {
        if condition() {
            modifier(self)
        } else {
            self
        }
    }

    /// Conditionally applies a modifier with a fallback for older OS versions.
    ///
    /// - Parameters:
    ///   - condition: A closure that returns true if the primary modifier should be applied
    ///   - primary: The modifier to apply when the condition is met
    ///   - fallback: The fallback modifier to apply when the condition is not met
    /// - Returns: The view with either the primary or fallback modifier applied
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .conditionally(
    ///         if: { someCondition },
    ///         apply: { $0.universalGlassEffect(.clear.interactive()) },
    ///         otherwise: { $0.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8)) }
    ///     )
    /// ```
    @ViewBuilder
    func conditionally<PrimaryContent: View, FallbackContent: View>(
        if condition: () -> Bool,
        apply primary: (Self) -> PrimaryContent,
        otherwise fallback: (Self) -> FallbackContent
    ) -> some View {
        if condition() {
            primary(self)
        } else {
            fallback(self)
        }
    }

    /// Conditionally applies modifiers with full control over availability checks.
    ///
    /// This version passes the view to a closure where you can perform your own
    /// `if #available` checks and apply different modifiers accordingly.
    ///
    /// - Parameter modifier: A closure that receives the view and can apply conditional modifiers
    /// - Returns: The view with conditionally applied modifiers
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .conditionally { view in
    ///         if #available(iOS 15.0, *) {
    ///             view.background(.regularMaterial, in: .rect(cornerRadius: 8))
    ///         } else {
    ///             view.background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 8))
    ///         }
    ///     }
    /// ```
    @ViewBuilder
    func conditionally<Content: View>(
        @ViewBuilder apply modifier: (Self) -> Content
    ) -> some View {
        modifier(self)
    }

    /// Conditionally applies a modifier if the provided optional value is non-nil.
    ///
    /// This variant automatically unwraps an optional value and passes it to the modifier closure,
    /// allowing you to apply modifiers based on optional data without manual unwrapping.
    ///
    /// - Parameters:
    ///   - optional: An optional value that determines if the modifier should be applied
    ///   - modifier: A closure that receives the view and unwrapped value when the optional is non-nil
    /// - Returns: The view with the modifier applied if the optional is non-nil, otherwise the original view
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .conditionally(if: optionalColor) { view, color in
    ///         view.foregroundStyle(color)
    ///     }
    ///
    /// // Or with more complex logic:
    /// Text("User Profile")
    ///     .conditionally(if: user?.avatarURL) { view, url in
    ///         view.background {
    ///             AsyncImage(url: url)
    ///         }
    ///     }
    /// ```
    @ViewBuilder
    func conditionally<Content: View, Value>(
        if optional: Value?,
        @ViewBuilder apply modifier: (Self, Value) -> Content
    ) -> some View {
        if let value = optional {
            modifier(self, value)
        } else {
            self
        }
    }

    /// Conditionally applies a modifier only if the condition is false.
    ///
    /// This is the negated variant of `conditionally(if:apply:)`. Sometimes `unless` reads
    /// better than `if: !condition`, making your code more semantic and easier to understand.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines if the modifier should NOT be applied.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - modifier: The modifier to apply when the condition is false
    /// - Returns: The view with the modifier applied when the condition is false, otherwise the original view
    ///
    /// Example:
    /// ```swift
    /// Text("Content")
    ///     .conditionally(unless: isCompact) { view in
    ///         view.padding(.horizontal, 40)
    ///     }
    ///
    /// // More readable than:
    /// // .conditionally(if: !isCompact) { ... }
    /// ```
    @ViewBuilder
    func conditionally<Content: View>(
        unless condition: @autoclosure () -> Bool,
        @ViewBuilder apply modifier: (Self) -> Content
    ) -> some View {
        if !condition() {
            modifier(self)
        } else {
            self
        }
    }
}

// MARK: - ToolbarContent Extensions

/// A ToolbarContent extension that provides clean conditional modifier application.
public extension ToolbarContent {
    /// Conditionally applies a modifier only if the current OS version supports it.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines if the modifier should be applied.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - modifier: The modifier to apply when the condition is met
    /// - Returns: The toolbar content with the modifier applied conditionally
    ///
    /// Example:
    /// ```swift
    /// ToolbarItem(placement: .topBarTrailing) {
    ///     Button("Action", action: {})
    /// }
    /// .conditionally(if: OSVersion.supportsGlassEffect) { content in
    ///     content.universalGlassEffect()
    /// }
    /// ```
    @ToolbarContentBuilder
    func conditionally<Content: ToolbarContent>(
        if condition: @autoclosure () -> Bool,
        @ToolbarContentBuilder apply modifier: (Self) -> Content
    ) -> some ToolbarContent {
        if condition() {
            modifier(self)
        } else {
            self
        }
    }

    /// Conditionally applies a modifier with a fallback for older OS versions.
    ///
    /// - Parameters:
    ///   - condition: A closure that returns true if the primary modifier should be applied
    ///   - primary: The modifier to apply when the condition is met
    ///   - fallback: The fallback modifier to apply when the condition is not met
    /// - Returns: The toolbar content with either the primary or fallback modifier applied
    ///
    /// Example:
    /// ```swift
    /// ToolbarItem(placement: .topBarTrailing) {
    ///     Button("Action", action: {})
    /// }
    /// .conditionally(
    ///     if: { OSVersion.supportsGlassEffect },
    ///     apply: { $0.universalGlassEffect() },
    ///     otherwise: { $0.background(.regularMaterial) }
    /// )
    /// ```
    @ToolbarContentBuilder
    func conditionally<PrimaryContent: ToolbarContent, FallbackContent: ToolbarContent>(
        if condition: () -> Bool,
        apply primary: (Self) -> PrimaryContent,
        otherwise fallback: (Self) -> FallbackContent
    ) -> some ToolbarContent {
        if condition() {
            primary(self)
        } else {
            fallback(self)
        }
    }

    /// Conditionally applies modifiers with full control over availability checks.
    ///
    /// This version passes the toolbar content to a closure where you can perform your own
    /// `if #available` checks and apply different modifiers accordingly.
    ///
    /// - Parameter modifier: A closure that receives the toolbar content and can apply conditional modifiers
    /// - Returns: The toolbar content with conditionally applied modifiers
    ///
    /// Example:
    /// ```swift
    /// ToolbarItem(placement: .topBarTrailing) {
    ///     Button("Action", action: {})
    /// }
    /// .conditionally { content in
    ///     if #available(iOS 15.0, *) {
    ///         content.background(.regularMaterial)
    ///     } else {
    ///         content.background(Color.gray.opacity(0.3))
    ///     }
    /// }
    /// ```
    @ToolbarContentBuilder
    func conditionally<Content: ToolbarContent>(
        @ToolbarContentBuilder apply modifier: (Self) -> Content
    ) -> some ToolbarContent {
        modifier(self)
    }

    /// Conditionally applies a modifier if the provided optional value is non-nil.
    ///
    /// This variant automatically unwraps an optional value and passes it to the modifier closure,
    /// allowing you to apply modifiers based on optional data without manual unwrapping.
    ///
    /// - Parameters:
    ///   - optional: An optional value that determines if the modifier should be applied
    ///   - modifier: A closure that receives the toolbar content and unwrapped value when the optional is non-nil
    /// - Returns: The toolbar content with the modifier applied if the optional is non-nil, otherwise the original content
    ///
    /// Example:
    /// ```swift
    /// ToolbarItem(placement: .topBarTrailing) {
    ///     Button("Action", action: {})
    /// }
    /// .conditionally(if: optionalTint) { content, tint in
    ///     content.tint(tint)
    /// }
    /// ```
    @ToolbarContentBuilder
    func conditionally<Content: ToolbarContent, Value>(
        if optional: Value?,
        @ToolbarContentBuilder apply modifier: (Self, Value) -> Content
    ) -> some ToolbarContent {
        if let value = optional {
            modifier(self, value)
        } else {
            self
        }
    }

    /// Conditionally applies a modifier only if the condition is false.
    ///
    /// This is the negated variant of `conditionally(if:apply:)`. Sometimes `unless` reads
    /// better than `if: !condition`, making your code more semantic and easier to understand.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines if the modifier should NOT be applied.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - modifier: The modifier to apply when the condition is false
    /// - Returns: The toolbar content with the modifier applied when the condition is false, otherwise the original content
    ///
    /// Example:
    /// ```swift
    /// ToolbarItem(placement: .topBarTrailing) {
    ///     Button("Action", action: {})
    /// }
    /// .conditionally(unless: isCompact) { content in
    ///     content.padding()
    /// }
    /// ```
    @ToolbarContentBuilder
    func conditionally<Content: ToolbarContent>(
        unless condition: @autoclosure () -> Bool,
        @ToolbarContentBuilder apply modifier: (Self) -> Content
    ) -> some ToolbarContent {
        if !condition() {
            modifier(self)
        } else {
            self
        }
    }
}

// MARK: - ToolbarItemPlacement Extensions

/// Extension for ToolbarItemPlacement to provide conditional placement based on OS availability.
public extension ToolbarItemPlacement {
    /// Returns a toolbar placement conditionally based on OS availability.
    ///
    /// - Parameters:
    ///   - modern: The placement to use on iOS 26+
    ///   - fallback: The placement to use on older iOS versions
    /// - Returns: The appropriate placement for the current OS version
    ///
    /// Example:
    /// ```swift
    /// ToolbarItemGroup(placement: .conditional(modern: .bottomBar, fallback: .secondaryAction)) {
    ///     // toolbar content
    /// }
    /// ```
    static func conditional(modern: ToolbarItemPlacement, fallback: ToolbarItemPlacement) -> ToolbarItemPlacement {
        if #available(iOS 26.0, *) {
            return modern
        } else {
            return fallback
        }
    }
}

// MARK: - OS Boolean Helpers

/// Helper for clean OS version checks with ternary operators.
public enum OS {
    /// Check if running iOS 26+
    ///
    /// Returns `true` when running on iOS 26.0 or later, `false` otherwise.
    ///
    /// Example:
    /// ```swift
    /// let effectStyle = OS.is26 ? .glass : .regular
    /// ```
    public static var is26: Bool {
        if #available(iOS 26.0, *) {
            return true
        } else {
            return false
        }
    }
}

// MARK: - OS Version Helpers

/// Helper functions for checking OS availability in a clean, readable way.
///
/// Provides a centralized way to check operating system versions at runtime,
/// which is useful for applying platform-specific features and modifiers.
public enum OSVersion {
    /// Check if running on iOS with minimum version.
    ///
    /// - Parameters:
    ///   - version: The major version number to check against
    ///   - patch: The patch version number (currently unused, for future enhancement)
    /// - Returns: `true` if the current iOS version is equal to or greater than the specified version
    ///
    /// Example:
    /// ```swift
    /// if OSVersion.iOS(18) {
    ///     // Use iOS 18+ features
    /// }
    /// ```
    public static func iOS(_ version: Int, _ patch: Int = 0) -> Bool {
        if #available(iOS 18.0, *) {
            return ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= version
        }
        return false
    }

    /// Check if running on macOS with minimum version.
    ///
    /// - Parameters:
    ///   - version: The major version number to check against
    ///   - patch: The patch version number (currently unused, for future enhancement)
    /// - Returns: `true` if the current macOS version is equal to or greater than the specified version
    ///
    /// Example:
    /// ```swift
    /// if OSVersion.macOS(14) {
    ///     // Use macOS 14+ features
    /// }
    /// ```
    public static func macOS(_ version: Int, _ patch: Int = 0) -> Bool {
        if #available(macOS 14.0, *) {
            return ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= version
        }
        return false
    }

    /// Check if running on watchOS with minimum version.
    ///
    /// - Parameters:
    ///   - version: The major version number to check against
    ///   - patch: The patch version number (currently unused, for future enhancement)
    /// - Returns: `true` if the current watchOS version is equal to or greater than the specified version
    ///
    /// Example:
    /// ```swift
    /// if OSVersion.watchOS(10) {
    ///     // Use watchOS 10+ features
    /// }
    /// ```
    public static func watchOS(_ version: Int, _ patch: Int = 0) -> Bool {
        if #available(watchOS 10.0, *) {
            return ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= version
        }
        return false
    }

    /// Check if running on tvOS with minimum version.
    ///
    /// - Parameters:
    ///   - version: The major version number to check against
    ///   - patch: The patch version number (currently unused, for future enhancement)
    /// - Returns: `true` if the current tvOS version is equal to or greater than the specified version
    ///
    /// Example:
    /// ```swift
    /// if OSVersion.tvOS(17) {
    ///     // Use tvOS 17+ features
    /// }
    /// ```
    public static func tvOS(_ version: Int, _ patch: Int = 0) -> Bool {
        if #available(tvOS 17.0, *) {
            return ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= version
        }
        return false
    }

    // MARK: - Convenience Helpers

    /// Check if running on iOS 26 or later (when glass effects were introduced).
    ///
    /// Returns `true` when running on iOS 26.0 or later, `false` otherwise.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .conditionally(if: OSVersion.supportsGlassEffect) { view in
    ///         view.background(.glass)
    ///     }
    /// ```
    public static var supportsGlassEffect: Bool {
        iOS(26)
    }
}

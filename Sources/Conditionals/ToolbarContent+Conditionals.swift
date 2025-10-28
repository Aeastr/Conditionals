//
//  ToolbarContent+Conditionals.swift
//  Conditionals
//
//  Created by Aether, 2025.
//
//  Copyright © 2025 Aether. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - ToolbarContent Extensions

/// A ToolbarContent extension that provides clean conditional modifier application.
public extension ToolbarContent {
    /// conditional applies a modifier only if the current OS version supports it.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines if the modifier should be applied.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - modifier: The modifier to apply when the condition is met
    /// - Returns: The toolbar content with the modifier applied conditional
    ///
    /// Example:
    /// ```swift
    /// ToolbarItem(placement: .topBarTrailing) {
    ///     Button("Action", action: {})
    /// }
    /// .conditional(if: OSVersion.supportsGlassEffect) { content in
    ///     content.universalGlassEffect()
    /// }
    /// ```
    @ToolbarContentBuilder
    func conditional<Content: ToolbarContent>(
        if condition: @autoclosure () -> Bool,
        @ToolbarContentBuilder apply modifier: (Self) -> Content
    ) -> some ToolbarContent {
        if condition() {
            modifier(self)
        } else {
            self
        }
    }

    /// conditional applies a modifier with a fallback for older OS versions.
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
    /// .conditional(
    ///     if: { OSVersion.supportsGlassEffect },
    ///     apply: { $0.universalGlassEffect() },
    ///     otherwise: { $0.background(.regularMaterial) }
    /// )
    /// ```
    @ToolbarContentBuilder
    func conditional<PrimaryContent: ToolbarContent, FallbackContent: ToolbarContent>(
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

    /// conditional applies modifiers with full control over availability checks.
    ///
    /// This version passes the toolbar content to a closure where you can perform your own
    /// `if #available` checks and apply different modifiers accordingly.
    ///
    /// - Parameter modifier: A closure that receives the toolbar content and can apply conditional modifiers
    /// - Returns: The toolbar content with conditional applied modifiers
    ///
    /// Example:
    /// ```swift
    /// ToolbarItem(placement: .topBarTrailing) {
    ///     Button("Action", action: {})
    /// }
    /// .conditional { content in
    ///     if #available(iOS 15.0, *) {
    ///         content.background(.regularMaterial)
    ///     } else {
    ///         content.background(Color.gray.opacity(0.3))
    ///     }
    /// }
    /// ```
    @ToolbarContentBuilder
    func conditional<Content: ToolbarContent>(
        @ToolbarContentBuilder apply modifier: (Self) -> Content
    ) -> some ToolbarContent {
        modifier(self)
    }

    /// conditional applies a modifier if the provided optional value is non-nil.
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
    /// .conditional(if: optionalTint) { content, tint in
    ///     content.tint(tint)
    /// }
    /// ```
    @ToolbarContentBuilder
    func conditional<Content: ToolbarContent, Value>(
        if optional: Value?,
        @ToolbarContentBuilder apply modifier: (Self, Value) -> Content
    ) -> some ToolbarContent {
        if let value = optional {
            modifier(self, value)
        } else {
            self
        }
    }

    /// conditional applies a modifier only if the condition is false.
    ///
    /// This is the negated variant of `conditional(if:apply:)`. Sometimes `unless` reads
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
    /// .conditional(unless: isCompact) { content in
    ///     content.padding()
    /// }
    /// ```
    @ToolbarContentBuilder
    func conditional<Content: ToolbarContent>(
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

// MARK: - Previews

#Preview("ToolbarContent Conditional") {
    NavigationStack {
        Text("Content")
            .toolbar {
                ToolbarItem(placement: .conditional {
                    #if os(iOS)
                    .topBarTrailing
                    #else
                    .automatic
                    #endif
                }) {
                    Button("Action") {}
                        .conditional(if: OSVersion.iOS(26)) { view in
                            view.tint(.blue)
                        }
                }
            }
            .navigationTitle("Toolbar Demo")
    }
}

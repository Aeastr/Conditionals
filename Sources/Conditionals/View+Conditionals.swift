//
//  View+Conditionals.swift
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
    /// conditional applies a modifier only if the current OS version supports it.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines if the modifier should be applied.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - modifier: The modifier to apply when the condition is met
    /// - Returns: The view with the modifier applied conditional
    ///
    /// The `@autoclosure` parameter allows clean syntax - you can write `OSVersion.supportsGlassEffect`
    /// instead of `{ OSVersion.supportsGlassEffect }`. The expression is automatically wrapped in a
    /// closure and only evaluated when needed, providing lazy evaluation.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .conditional(if: someCondition) { view in
    ///         view.padding(.large)
    ///     }
    /// ```
    @ViewBuilder
    func conditional<Content: View>(
        if condition: @autoclosure () -> Bool,
        @ViewBuilder apply modifier: (Self) -> Content
    ) -> some View {
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
    /// - Returns: The view with either the primary or fallback modifier applied
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .conditional(
    ///         if: { someCondition },
    ///         apply: { $0.universalGlassEffect(.clear.interactive()) },
    ///         otherwise: { $0.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8)) }
    ///     )
    /// ```
    @ViewBuilder
    func conditional<PrimaryContent: View, FallbackContent: View>(
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

    /// conditional applies modifiers with full control over availability checks.
    ///
    /// This version passes the view to a closure where you can perform your own
    /// `if #available` checks and apply different modifiers accordingly.
    ///
    /// - Parameter modifier: A closure that receives the view and can apply conditional modifiers
    /// - Returns: The view with conditional applied modifiers
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .conditional { view in
    ///         if #available(iOS 15.0, *) {
    ///             view.background(.regularMaterial, in: .rect(cornerRadius: 8))
    ///         } else {
    ///             view.background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 8))
    ///         }
    ///     }
    /// ```
    @ViewBuilder
    func conditional<Content: View>(
        @ViewBuilder apply modifier: (Self) -> Content
    ) -> some View {
        modifier(self)
    }

    /// conditional applies a modifier if the provided optional value is non-nil.
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
    ///     .conditional(if: optionalColor) { view, color in
    ///         view.foregroundStyle(color)
    ///     }
    ///
    /// // Or with more complex logic:
    /// Text("User Profile")
    ///     .conditional(if: user?.avatarURL) { view, url in
    ///         view.background {
    ///             AsyncImage(url: url)
    ///         }
    ///     }
    /// ```
    @ViewBuilder
    func conditional<Content: View, Value>(
        if optional: Value?,
        @ViewBuilder apply modifier: (Self, Value) -> Content
    ) -> some View {
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
    /// - Returns: The view with the modifier applied when the condition is false, otherwise the original view
    ///
    /// Example:
    /// ```swift
    /// Text("Content")
    ///     .conditional(unless: isCompact) { view in
    ///         view.padding(.horizontal, 40)
    ///     }
    ///
    /// // More readable than:
    /// // .conditional(if: !isCompact) { ... }
    /// ```
    @ViewBuilder
    func conditional<Content: View>(
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

// MARK: - Previews

#Preview("Basic View Conditional") {
    VStack(spacing: 20) {
        Text("iOS 26+ Styling")
            .conditional(if: OSVersion.iOS(26)) { view in
                view
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }

        Text("With Fallback")
            .padding()
            .conditional { view in
                #if os(iOS) || os(macOS)
                if #available(iOS 26.0, macOS 26.0, *) {
                    view.glassEffect(.regular, in: .rect(cornerRadius: 12))
                } else if #available(iOS 18.0, macOS 18.0, *) {
                    view.background(.regularMaterial, in: .rect(cornerRadius: 12))
                } else {
                    view.background(Color.gray.opacity(0.2), in: .rect(cornerRadius: 12))
                }
                #elseif os(watchOS)
                if #available(watchOS 10.0, *) {
                    view.background(.regularMaterial, in: .rect(cornerRadius: 12))
                } else {
                    view.background(Color.gray.opacity(0.2), in: .rect(cornerRadius: 12))
                }
                #else
                view.background(Color.gray.opacity(0.2), in: .rect(cornerRadius: 12))
                #endif
            }
    }
    .padding()
}

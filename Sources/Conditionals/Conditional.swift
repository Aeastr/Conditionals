//
//  Conditional.swift
//  Conditionals
//
//  Created by Aether, 2025.
//
//  Copyright © 2025 Aether. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - Future Consideration: Static Protocol Pattern
//
// An alternative API design could enforce static-only conditions at the type level
// using a protocol with a static requirement:
//
//     protocol StaticCondition {
//         static var isMet: Bool { get }
//     }
//
//     // Library ships pre-defined conditions:
//     public enum iOS17: StaticCondition {
//         public static var isMet: Bool { OSVersion.iOS(17) }
//     }
//
//     // Usage becomes type-based:
//     .conditional(iOS17.self) { $0.fontDesign(.rounded) }
//
// Why this pattern works:
// - Makes misuse inconvenient rather than impossible (which is enough)
// - Passing runtime state like `isActive` would require defining a type,
//   accessing instance state from a static context (awkward), and likely
//   using a singleton/global (obvious code smell)
// - Nobody does that accidentally - the friction IS the enforcement
// - Signals intent at the API level: types feel more deliberate than bools
//
// Trade-offs vs current `OSVersion.iOS(17)` approach:
// - Lose: Parameterized syntax flexibility
// - Gain: Type-level intent, harder to accidentally pass runtime state
//
// Could potentially offer both APIs and let users choose their strictness level.
//
// Inspired by Engine's (https://github.com/nathantannar4/Engine) use of
// static protocol vars to enforce compile-time condition specification.

// MARK: - Conditional Protocol

/// A protocol that enables conditional value selection and transformation based on availability checks.
///
/// This protocol provides two categories of conditional methods:
/// 1. **Value selection** (static methods) - For selecting between pre-computed values
/// 2. **Transformation** (instance methods) - For applying transformations/modifiers conditionally
///
/// Types conforming to this protocol gain both value selection and transformation capabilities,
/// particularly useful for handling OS version availability checks where `#available` is needed.
///
/// Example conforming types:
/// - `View` - Uses transformation methods for conditional modifier application
/// - `ToolbarContent` - Uses transformation methods for conditional toolbar modifiers
/// - `ToolbarItemPlacement` - Uses value selection methods for conditional placement
public protocol Conditional {}

// MARK: - Value Selection (Static Methods)

public extension Conditional {
    /// Returns a value conditionally based on a boolean condition.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines which value to return.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - primary: The value to return when the condition is true
    ///   - fallback: The value to return when the condition is false
    /// - Returns: The appropriate value based on the condition
    ///
    /// Example:
    /// ```swift
    /// ToolbarItemGroup(
    ///     placement: .conditional(
    ///         if: OSVersion.iOS(26),
    ///         then: .bottomBar,
    ///         else: .secondaryAction
    ///     )
    /// ) {
    ///     Button("Edit") {}
    /// }
    /// ```
    static func conditional(
        if condition: @autoclosure () -> Bool,
        then primary: Self,
        else fallback: Self
    ) -> Self {
        condition() ? primary : fallback
    }

    /// Returns a value with full control over availability checks.
    ///
    /// This version accepts a closure where you can perform your own `if #available` checks
    /// and return different values accordingly.
    ///
    /// - Parameter builder: A closure that returns the appropriate value
    /// - Returns: The value returned by the builder
    ///
    /// Example:
    /// ```swift
    /// ToolbarItemGroup(
    ///     placement: .conditional {
    ///         if #available(iOS 26.0, *) {
    ///             .bottomBar
    ///         } else if #available(iOS 17.0, *) {
    ///             .secondaryAction
    ///         } else {
    ///             .automatic
    ///         }
    ///     }
    /// ) {
    ///     Button("Edit") {}
    /// }
    /// ```
    static func conditional(_ builder: () -> Self) -> Self {
        builder()
    }

    /// Returns a value conditionally based on a negated condition.
    ///
    /// This is the negated variant of `conditional(if:then:else:)`. Sometimes `unless` reads
    /// better than `if: !condition`, making your code more semantic and easier to understand.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines which value to NOT return.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - primary: The value to return when the condition is false
    ///   - fallback: The value to return when the condition is true
    /// - Returns: The appropriate value based on the negated condition
    ///
    /// Example:
    /// ```swift
    /// ToolbarItemGroup(
    ///     placement: .conditional(
    ///         unless: isCompact,
    ///         then: .principal,
    ///         else: .automatic
    ///     )
    /// ) {
    ///     Text("Title")
    /// }
    /// ```
    static func conditional(
        unless condition: @autoclosure () -> Bool,
        then primary: Self,
        else fallback: Self
    ) -> Self {
        !condition() ? primary : fallback
    }
}

// MARK: - Transformation (Instance Methods)
// Note: These provide default implementations. View and ToolbarContent override with @ViewBuilder/@ToolbarContentBuilder.

public extension Conditional {
    /// Applies a transformation conditionally based on a boolean condition.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines if the transformation should be applied.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - modifier: The transformation to apply when the condition is met
    /// - Returns: The transformed result when the condition is true, otherwise the original value
    ///
    /// Note: View and ToolbarContent provide specialized versions with @ViewBuilder/@ToolbarContentBuilder.
    func conditional(
        if condition: @autoclosure () -> Bool,
        apply modifier: (Self) -> Self
    ) -> Self {
        if condition() {
            return modifier(self)
        } else {
            return self
        }
    }

    /// Applies a transformation with a fallback when the condition is false.
    ///
    /// - Parameters:
    ///   - condition: A closure that returns true if the primary transformation should be applied
    ///   - primary: The transformation to apply when the condition is met
    ///   - fallback: The fallback transformation to apply when the condition is not met
    /// - Returns: The result of either the primary or fallback transformation
    ///
    /// Note: View and ToolbarContent provide specialized versions with @ViewBuilder/@ToolbarContentBuilder.
    func conditional(
        if condition: () -> Bool,
        apply primary: (Self) -> Self,
        otherwise fallback: (Self) -> Self
    ) -> Self {
        if condition() {
            return primary(self)
        } else {
            return fallback(self)
        }
    }

    /// Applies transformations with full control over availability checks.
    ///
    /// This version passes the value to a closure where you can perform your own
    /// `if #available` checks and apply different transformations accordingly.
    ///
    /// - Parameter modifier: A closure that receives the value and can apply conditional transformations
    /// - Returns: The transformed result
    ///
    /// Note: View and ToolbarContent provide specialized versions with @ViewBuilder/@ToolbarContentBuilder.
    func conditional(
        apply modifier: (Self) -> Self
    ) -> Self {
        modifier(self)
    }

    /// Applies a transformation if the provided optional value is non-nil.
    ///
    /// This variant automatically unwraps an optional value and passes it to the transformation closure,
    /// allowing you to apply transformations based on optional data without manual unwrapping.
    ///
    /// - Parameters:
    ///   - optional: An optional value that determines if the transformation should be applied
    ///   - modifier: A closure that receives the value and unwrapped optional when it's non-nil
    /// - Returns: The transformed result if the optional is non-nil, otherwise the original value
    ///
    /// Note: View and ToolbarContent provide specialized versions with @ViewBuilder/@ToolbarContentBuilder.
    func conditional<Value>(
        if optional: Value?,
        apply modifier: (Self, Value) -> Self
    ) -> Self {
        if let value = optional {
            return modifier(self, value)
        } else {
            return self
        }
    }

    /// Applies a transformation only if the condition is false.
    ///
    /// This is the negated variant of `conditional(if:apply:)`. Sometimes `unless` reads
    /// better than `if: !condition`, making your code more semantic and easier to understand.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines if the transformation should NOT be applied.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - modifier: The transformation to apply when the condition is false
    /// - Returns: The transformed result when the condition is false, otherwise the original value
    ///
    /// Note: View and ToolbarContent provide specialized versions with @ViewBuilder/@ToolbarContentBuilder.
    func conditional(
        unless condition: @autoclosure () -> Bool,
        apply modifier: (Self) -> Self
    ) -> Self {
        if !condition() {
            return modifier(self)
        } else {
            return self
        }
    }
}

// MARK: - Free Functions

/// Returns a value conditionally based on a boolean condition.
///
/// Use this function for types that don't conform to `Conditional` protocol.
/// For conforming types, prefer using the static method `.conditional(if:then:else:)`.
///
/// - Parameters:
///   - condition: A boolean expression that determines which value to return.
///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
///   - primary: The value to return when the condition is true
///   - fallback: The value to return when the condition is false
/// - Returns: The appropriate value based on the condition
///
/// Example:
/// ```swift
/// let color = conditional(
///     if: isDarkMode,
///     then: Color.white,
///     else: Color.black
/// )
///
/// Text("Hello")
///     .foregroundStyle(
///         conditional(
///             if: OSVersion.iOS(17),
///             then: Color.red.gradient,
///             else: Color.red
///         )
///     )
/// ```
public func conditional<T>(
    if condition: @autoclosure () -> Bool,
    then primary: T,
    else fallback: T
) -> T {
    condition() ? primary : fallback
}

/// Returns a value with full control over availability checks.
///
/// Use this function for types that don't conform to `Conditional` protocol.
/// For conforming types, prefer using the static method `.conditional(_:)`.
///
/// This version accepts a closure where you can perform your own `if #available` checks
/// and return different values accordingly.
///
/// - Parameter builder: A closure that returns the appropriate value
/// - Returns: The value returned by the builder
///
/// Example:
/// ```swift
/// let detent = conditional {
///     if #available(iOS 16.0, *) {
///         PresentationDetent.height(300)
///     } else {
///         .medium
///     }
/// }
///
/// .presentationDetents([
///     conditional {
///         if #available(iOS 16.0, *) {
///             .height(300)
///         } else {
///             .medium
///         }
///     }
/// ])
/// ```
public func conditional<T>(_ builder: () -> T) -> T {
    builder()
}

/// Returns a value conditionally based on a negated condition.
///
/// Use this function for types that don't conform to `Conditional` protocol.
/// For conforming types, prefer using the static method `.conditional(unless:then:else:)`.
///
/// This is the negated variant of `conditional(if:then:else:)`. Sometimes `unless` reads
/// better than `if: !condition`, making your code more semantic and easier to understand.
///
/// - Parameters:
///   - condition: A boolean expression that determines which value to NOT return.
///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
///   - primary: The value to return when the condition is false
///   - fallback: The value to return when the condition is true
/// - Returns: The appropriate value based on the negated condition
///
/// Example:
/// ```swift
/// let padding = conditional(
///     unless: isCompact,
///     then: 40.0,
///     else: 16.0
/// )
/// ```
public func conditional<T>(
    unless condition: @autoclosure () -> Bool,
    then primary: T,
    else fallback: T
) -> T {
    !condition() ? primary : fallback
}

/// Returns a value if an optional is non-nil, otherwise returns a fallback value.
///
/// This variant automatically unwraps an optional value and passes it to a transform closure,
/// allowing you to conditionally derive values based on optional data without manual unwrapping.
///
/// - Parameters:
///   - optional: An optional value that determines which value to return
///   - transform: A closure that transforms the unwrapped value when the optional is non-nil
///   - fallback: The value to return when the optional is nil
/// - Returns: The transformed value if the optional is non-nil, otherwise the fallback value
///
/// Example:
/// ```swift
/// let color = conditional(
///     if: userPreferredColor,
///     transform: { $0 },
///     else: Color.blue
/// )
///
/// let spacing = conditional(
///     if: customSpacing,
///     transform: { $0 * 2 },
///     else: 16.0
/// )
/// ```
public func conditional<T, Value>(
    if optional: Value?,
    transform: (Value) -> T,
    else fallback: T
) -> T {
    if let value = optional {
        return transform(value)
    } else {
        return fallback
    }
}

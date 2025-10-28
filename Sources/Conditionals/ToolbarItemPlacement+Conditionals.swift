//
//  ToolbarItemPlacement+Conditionals.swift
//  Conditionals
//
//  Created by Aether, 2025.
//
//  Copyright © 2025 Aether. All rights reserved.
//  Licensed under the MIT License.
// 

import SwiftUI

// MARK: - ToolbarItemPlacement Extensions

/// Extension for ToolbarItemPlacement to provide conditional placement based on conditions.
public extension ToolbarItemPlacement {
    /// Returns a toolbar placement conditional based on a boolean condition.
    ///
    /// - Parameters:
    ///   - condition: A boolean expression that determines which placement to use.
    ///                Uses `@autoclosure` so you can pass expressions directly without wrapping in `{ }`.
    ///   - primary: The placement to use when the condition is true
    ///   - fallback: The placement to use when the condition is false
    /// - Returns: The appropriate placement based on the condition
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
    ///     Button("Share") {}
    /// }
    /// ```
    static func conditional(
        if condition: @autoclosure () -> Bool,
        then primary: ToolbarItemPlacement,
        else fallback: ToolbarItemPlacement
    ) -> ToolbarItemPlacement {
        condition() ? primary : fallback
    }

    /// Returns a toolbar placement conditional with full control over availability checks.
    ///
    /// This version accepts a closure where you can perform your own `if #available` checks
    /// and return different placements accordingly.
    ///
    /// - Parameter builder: A closure that returns the appropriate placement
    /// - Returns: The placement returned by the builder
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
    ///     Button("Share") {}
    /// }
    /// ```
    static func conditional(
        _ builder: () -> ToolbarItemPlacement
    ) -> ToolbarItemPlacement {
        builder()
    }
}

// MARK: - Previews

#Preview("ToolbarItemPlacement Conditional") {
    NavigationStack {
        Text("Content")
            .toolbar {
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
                    Button("Share") {}
                }
            }
            .navigationTitle("Placement Demo")
    }
}

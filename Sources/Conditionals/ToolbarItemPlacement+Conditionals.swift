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

// MARK: - ToolbarItemPlacement Conformance

/// Conformance to Conditional protocol, enabling conditional placement selection.
///
/// This conformance allows ToolbarItemPlacement to use the `.conditional()` methods
/// for selecting placements based on OS availability or other conditions.
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
///
/// // Or with #available checks:
/// ToolbarItemGroup(
///     placement: .conditional {
///         if #available(iOS 26.0, *) {
///             .bottomBar
///         } else {
///             .secondaryAction
///         }
///     }
/// ) {
///     Button("Edit") {}
/// }
/// ```
extension ToolbarItemPlacement: Conditional {}

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

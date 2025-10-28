//
//  OSVersion.swift
//  Conditionals
//
//  Created by Aether, 2025.
//
//  Copyright © 2025 Aether. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import Foundation

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
    ///     .conditional(if: OSVersion.supportsGlassEffect) { view in
    ///         view.background(.glass)
    ///     }
    /// ```
    public static var supportsGlassEffect: Bool {
        iOS(26)
    }
}

// MARK: - Previews

#Preview("OSVersion Helpers") {
    VStack(spacing: 16) {
        Group {
            Text("iOS 16+: \(OSVersion.iOS(16) ? "✓" : "✗")")
            Text("iOS 18+: \(OSVersion.iOS(18) ? "✓" : "✗")")
            Text("iOS 26+: \(OSVersion.iOS(26) ? "✓" : "✗")")
        }
        .font(.body)

        Divider()

        Text(OS.is26 ? "Running iOS 26+" : "Running older iOS")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
}

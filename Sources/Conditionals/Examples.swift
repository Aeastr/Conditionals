//
//  Examples.swift
//  Conditionals
//
//  Created by Aether, 2025.
//
//  Copyright © 2025 Aether. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// MARK: - Basic Conditional Examples

#Preview("Basic Conditional") {
    VStack(spacing: 20) {
        Text("With Padding")
            .conditionally(if: true) { view in
                view.padding(30)
            }

        Text("Without Padding")
            .conditionally(if: false) { view in
                view.padding(30)
            }
    }
}

#Preview("OS Version Check") {
    Text("Hello, World!")
        .font(.title)
        .conditionally(if: OSVersion.iOS(16)) { view in
            view
                .padding()
                .background(.regularMaterial, in: .rect(cornerRadius: 12))
        }
}

// MARK: - Primary/Fallback Examples

#Preview("Primary with Fallback") {
    Text("Adaptive Background")
        .padding()
        .conditionally(
            if: { OSVersion.iOS(18) },
            apply: { view in
                view.background(.thinMaterial, in: .rect(cornerRadius: 16))
            },
            otherwise: { view in
                view.background(Color.gray.opacity(0.2), in: .rect(cornerRadius: 16))
            }
        )
}

// MARK: - Availability Check Examples

#Preview("Manual Availability Check") {
    Text("Platform-Specific Styling")
        .conditionally { view in
            if #available(iOS 17.0, *) {
                view
                    .fontDesign(.rounded)
                    .padding()
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
            } else {
                view
                    .padding()
                    .background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 12))
            }
        }
}

// MARK: - OS Version Examples (Primary Use Cases)

#Preview("OS Version Features") {
    VStack(spacing: 16) {
        Text("iOS 18+ Styling")
            .conditionally(if: OSVersion.iOS(18)) { view in
                view
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }

        Text("iOS 17+ Material")
            .padding()
            .conditionally(if: OSVersion.iOS(17)) { view in
                view.background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
            }

        Text("iOS 16+ Rounded")
            .conditionally(if: OSVersion.iOS(16)) { view in
                view
                    .padding()
                    .background(.thinMaterial, in: .rect(cornerRadius: 8))
            }
    }
    .padding()
}

// MARK: - Gated Features (iOS 26+)

#Preview("Liquid Glass Effect") {
    Text("Glass Effect")
        .font(.title)
        .padding()
        .conditionally { view in
            if #available(iOS 26.0, *) {
                // Compiler-gated feature requires #available
                view.glassEffect(.regular, in: .rect(cornerRadius: 16))
            } else {
                view.background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
            }
        }
}

#Preview("Conditional Glass with Fallback") {
    VStack(spacing: 20) {
        Text("Modern Glass")
            .padding()
            .conditionally { view in
                // For iOS 26+ features, wrap in #available
                if #available(iOS 26.0, *) {
                    view.background(.regularMaterial, in: .rect(cornerRadius: 12))
                } else {
                    view.background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 12))
                }
            }
    }
}

// MARK: - Toolbar Examples

#Preview("Toolbar Conditional") {
    NavigationStack {
        Text("Content")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Action") {}
                        .conditionally(if: OSVersion.iOS(16)) { view in
                            view.tint(.blue)
                        }
                }
            }
            .navigationTitle("Toolbar Demo")
    }
}


#Preview("Conditional Toolbar Placement") {
    NavigationStack {
        Text("Content")
            .toolbar {
                ToolbarItemGroup(
                    placement: .conditional(
                        modern: .bottomBar,
                        fallback: .secondaryAction
                    )
                ) {
                    Button("Edit") {}
                    Button("Share") {}
                }
            }
            .navigationTitle("Placement Demo")
    }
}

// MARK: - Complex Real-World Examples

#Preview("Adaptive Card") {
    struct Card: View {
        let title: String
        let subtitle: String

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            // ✅ GOOD: OS version check is static
            .conditionally(
                if: { OSVersion.iOS(17) },
                apply: { view in
                    view.background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                },
                otherwise: { view in
                    view.background(Color(.systemGray6), in: .rect(cornerRadius: 12))
                }
            )
            .shadow(radius: 2)
        }
    }

    return VStack(spacing: 16) {
        Card(title: "Modern Card", subtitle: "iOS 17+ uses material")
        Card(title: "Fallback Card", subtitle: "iOS 16 uses solid color")
        Card(title: "Consistent Styling", subtitle: "All cards have same structure")
    }
    .padding()
}

#Preview("Multi-Platform View") {
    Text("Cross-Platform")
        .font(.title)
        .conditionally { view in
            #if os(iOS)
            if #available(iOS 17.0, *) {
                view
                    .padding()
                    .background(.regularMaterial, in: .rect(cornerRadius: 12))
            } else {
                view.padding()
            }
            #elseif os(macOS)
            view
                .padding()
                .background(Color(.windowBackgroundColor))
            #else
            view.padding()
            #endif
        }
}

// MARK: - OS Version Helper Examples

#Preview("OS Version Helpers") {
    VStack(spacing: 16) {
        Group {
            Text("iOS 16+: \(OSVersion.iOS(16) ? "✓" : "✗")")
            Text("iOS 18+: \(OSVersion.iOS(18) ? "✓" : "✗")")
            Text("iOS 26+: \(OSVersion.iOS(26) ? "✓" : "✗")")
        }
        .conditionally(if: OSVersion.iOS(16)) { view in
            view
                .padding()
                .background(.thinMaterial, in: .rect(cornerRadius: 8))
        }

        Text(OS.is26 ? "Running iOS 26+" : "Running older iOS")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
}

// MARK: - Unless (Negated) Examples

#Preview("Unless Variant") {
    VStack(spacing: 20) {
        let isCompact = false

        Text("With Unless")
            .conditionally(unless: isCompact) { view in
                view.padding(.horizontal, 40)
            }

        Text("More Readable")
            .font(.headline)
            .conditionally(unless: isCompact) { view in
                view
                    .frame(maxWidth: 400)
                    .padding()
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
            }

        // Compare to using 'if: !'
        Text("Using If: !")
            .conditionally(if: !isCompact) { view in
                view.padding(.horizontal, 40)
            }
    }
}


// MARK: - View Identity & Performance Best Practices

#Preview("❌ BAD: View Identity Loss") {
    struct BadExample: View {
        @State private var items: [String] = []
        @State private var counter = 0

        var body: some View {
            VStack(spacing: 20) {
                Text("Counter: \(counter)")
                    .font(.title)
                    // ❌ BAD: Wrapping the entire view changes its identity
                    .conditionally(if: !items.isEmpty) { view in
                        view.badge(items.count)
                    }

                Text("This state will RESET when items changes from empty ↔ non-empty")
                    .font(.caption)
                    .foregroundStyle(.red)

                Button("Increment Counter") {
                    counter += 1
                }

                Button(items.isEmpty ? "Add Item" : "Clear Items") {
                    if items.isEmpty {
                        items = ["Item 1"]
                    } else {
                        items = []
                    }
                }

                Text("Try: Increment counter, then toggle items - counter resets!")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }

    return BadExample()
}

#Preview("✅ GOOD: Preserve View Identity") {
    struct GoodExample: View {
        @State private var items: [String] = []
        @State private var counter = 0

        var body: some View {
            VStack(spacing: 20) {
                Text("Counter: \(counter)")
                    .font(.title)
                    // ✅ GOOD: Use overlay to preserve view identity
                    .overlay(alignment: .topTrailing) {
                        if !items.isEmpty {
                            Text("\(items.count)")
                                .font(.caption2)
                                .padding(4)
                                .background(.red, in: Circle())
                                .foregroundStyle(.white)
                                .offset(x: 10, y: -10)
                        }
                    }

                Text("State is PRESERVED - view identity never changes")
                    .font(.caption)
                    .foregroundStyle(.green)

                Button("Increment Counter") {
                    counter += 1
                }

                Button(items.isEmpty ? "Add Item" : "Clear Items") {
                    if items.isEmpty {
                        items = ["Item 1"]
                    } else {
                        items = []
                    }
                }

                Text("Counter stays stable when toggling items ✓")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }

    return GoodExample()
}

#Preview("✅ Safe Conditional Usage") {
    VStack(spacing: 20) {
        // ✅ GOOD: Modifiers that don't change view identity
        Text("Safe Styling")
            .conditionally(if: OSVersion.iOS(17)) { view in
                view
                    .font(.body)
                    .foregroundStyle(.blue)
            }

        // ✅ GOOD: Background/overlay within conditional is fine
        Text("Safe Effects")
            .conditionally(if: OSVersion.iOS(17)) { view in
                view.background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
            }

        // ✅ GOOD: Animation and transition modifiers are safe
        Text("Safe Animations")
            .conditionally(if: OSVersion.iOS(16)) { view in
                view.transition(.scale)
            }

        Divider()

        Text("Rule: Use conditionals for styling, not structure")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
}

#Preview("❌ vs ✅ Collection Badge Pattern") {
    struct ComparisonView: View {
        @State private var badItems: [String] = []
        @State private var goodItems: [String] = []
        @State private var badCounter = 0
        @State private var goodCounter = 0

        var body: some View {
            HStack(spacing: 40) {
                // ❌ BAD SIDE
                VStack(spacing: 12) {
                    Text("❌ BAD")
                        .font(.headline)
                        .foregroundStyle(.red)

                    Text("Taps: \(badCounter)")
                        .conditionally(if: !badItems.isEmpty) { view in
                            view.badge(badItems.count)
                        }
                        .onTapGesture {
                            badCounter += 1
                        }

                    Button("Toggle Items") {
                        if badItems.isEmpty {
                            badItems = ["A", "B"]
                        } else {
                            badItems = []
                        }
                    }

                    Text("Counter resets!")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity)

                Divider()

                // ✅ GOOD SIDE
                VStack(spacing: 12) {
                    Text("✅ GOOD")
                        .font(.headline)
                        .foregroundStyle(.green)

                    Text("Taps: \(goodCounter)")
                        .overlay(alignment: .topTrailing) {
                            if !goodItems.isEmpty {
                                Text("\(goodItems.count)")
                                    .font(.caption2)
                                    .padding(4)
                                    .background(.red, in: Circle())
                                    .foregroundStyle(.white)
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            goodCounter += 1
                        }

                    Button("Toggle Items") {
                        if goodItems.isEmpty {
                            goodItems = ["A", "B"]
                        } else {
                            goodItems = []
                        }
                    }

                    Text("Counter preserved!")
                        .font(.caption2)
                        .foregroundStyle(.green)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }

    return ComparisonView()
}

#Preview("Performance: When to Use Conditionals") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            Group {
                Text("✅ GOOD USE CASES")
                    .font(.headline)
                    .foregroundStyle(.green)

                VStack(alignment: .leading, spacing: 8) {
                    Label("Styling & Colors", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Text(\"Hello\").conditionally(if: isDark) { $0.foregroundStyle(.white) }")
                        .font(.caption)
                        .monospaced()

                    Label("Font & Design", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Text(\"Title\").conditionally(if: iOS17) { $0.fontDesign(.rounded) }")
                        .font(.caption)
                        .monospaced()

                    Label("Padding & Spacing", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("VStack().conditionally(if: isLarge) { $0.padding(40) }")
                        .font(.caption)
                        .monospaced()

                    Label("Static Backgrounds", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("View.conditionally(if: iOS17) { $0.background(.material) }")
                        .font(.caption)
                        .monospaced()
                }
            }
            .padding()
            .background(.green.opacity(0.1), in: .rect(cornerRadius: 12))

            Group {
                Text("❌ BAD USE CASES")
                    .font(.headline)
                    .foregroundStyle(.red)

                VStack(alignment: .leading, spacing: 8) {
                    Label("Collection-dependent badges", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("Use overlay { if !items.isEmpty { Badge() } } instead")
                        .font(.caption)

                    Label("State-dependent content", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("Use if/switch in body, not conditional wrapper")
                        .font(.caption)

                    Label("Animated transitions", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("Changing view identity breaks animations")
                        .font(.caption)

                    Label("Complex view trees", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("Wrap individual modifiers, not entire hierarchies")
                        .font(.caption)
                }
            }
            .padding()
            .background(.red.opacity(0.1), in: .rect(cornerRadius: 12))

            Group {
                Text("💡 GOLDEN RULE")
                    .font(.headline)

                Text("If the condition can change at runtime based on app state, use if/overlay/background inside view builders. Conditionals are best for OS/platform checks that don't change.")
                    .font(.subheadline)
            }
            .padding()
            .background(.blue.opacity(0.1), in: .rect(cornerRadius: 12))
        }
        .padding()
    }
}

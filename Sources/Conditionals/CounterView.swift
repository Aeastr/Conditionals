//
//  CounterView.swift
//  Conditionals
//
//  Created by Aether on 10/28/25.
//


import SwiftUI

// MARK: - Test View with State

struct CounterView: View {
    @State private var count = 0
    @State private var applyModifier = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .font(.largeTitle)
            
            Button("Increment") {
                count += 1
            }
            .buttonStyle(.borderedProminent)
            
            Toggle("Apply Modifier", isOn: $applyModifier)
                .padding()
            
            Text("If view identity is preserved, count should NOT reset when toggling the modifier")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        // THIS IS THE TEST: Does toggling this conditional reset the state?
        .conditionally(if: applyModifier) { view in
            view
                .background(Color.blue.opacity(0.2))
                .cornerRadius(16)
        }
    }
}

// MARK: - Control Test: Known Bad Pattern

struct CounterViewBad: View {
    @State private var count = 0
    @State private var showAsCard = false
    
    var body: some View {
        VStack(spacing: 20) {
            if showAsCard {
                // This DEFINITELY breaks identity - it's a different view type
                CardWrapper {
                    counterContent
                }
            } else {
                counterContent
            }
            
            Text("This SHOULD reset count when toggling (known bad pattern)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
    
    var counterContent: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .font(.largeTitle)
            
            Button("Increment") {
                count += 1
            }
            .buttonStyle(.borderedProminent)
            
            Toggle("Show as Card", isOn: $showAsCard)
                .padding()
        }
    }
}

struct CardWrapper<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        content()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(16)
    }
}

// MARK: - Test Runner

#Preview("Conditional Modifier Test") {
    CounterView()
}

#Preview("Known Bad Pattern") {
    CounterViewBad()
}

// MARK: - Additional Test: State Across Modifier Changes

struct DetailedIdentityTest: View {
    @State private var counter = 0
    @State private var condition = false
    @State private var textFieldValue = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Counter: \(counter)")
            Button("+1") { counter += 1 }
            
            TextField("Type something", text: $textFieldValue)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Toggle("Toggle Condition", isOn: $condition)
            
            Text("Expected: Counter and text field should preserve state")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .conditionally(if: condition) { view in
            view
                .background(Color.green.opacity(0.2))
                .border(Color.green, width: 2)
        }
    }
}

#Preview("Detailed Identity Test") {
    DetailedIdentityTest()
}

// MARK: - Test with Animation

struct AnimationIdentityTest: View {
    @State private var counter = 0
    @State private var condition = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Counter: \(counter)")
                .font(.largeTitle)
            
            Button("+1") { 
                withAnimation {
                    counter += 1
                }
            }
            
            Toggle("Toggle Condition", isOn: $condition.animation())
            
            Text("Expected: Smooth animation, no state reset")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .conditionally(if: condition) { view in
            view
                .background(Color.purple.opacity(0.2))
                .scaleEffect(condition ? 1.1 : 1.0)
        }
    }
}

#Preview("Animation Identity Test") {
    AnimationIdentityTest()
}

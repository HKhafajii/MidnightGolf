import SwiftUI

struct AdminVerificationSheetView: View {
    @State private var pin: [Int] = []
    let adminPin = [3, 2, 9, 8]
    let maxDigits = 4
    @State private var showError = false
    @State private var navigateToNextScreen = false

    var body: some View {
        NavigationStack {
            

            
            ZStack {
                
                Image("bg")
                
                VStack {
                    Spacer()
                    
                    // PIN Circles
                    HStack(spacing: 15) {
                        ForEach(0..<maxDigits, id: \.self) { index in
                            Circle()
                                .strokeBorder(Color.blue, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .fill(pin.count > index ? Color.blue : Color.clear)
                                        .frame(width: 10, height: 10)
                                )
                        }
                    }
                    .padding()
                    
                    if showError {
                        Text("Incorrect PIN")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    // Number Pad
                    VStack(spacing: 10) {
                        // First three rows
                        ForEach(0..<3) { row in
                            HStack(spacing: 10) {
                                ForEach(1...3, id: \.self) { col in
                                    let number = row * 3 + col
                                    PinButton(number: number) {
                                        addDigit(number)
                                    }
                                }
                            }
                        }
                        
                        // Bottom row with 0 and backspace
                        HStack(spacing: 10) {
                            // Placeholder to align 0 under the 8
                            Spacer()
                                .frame(width: 60)
                            
                            // 0 Button
                            PinButton(number: 0) {
                                addDigit(0)
                            }
                            
                            // Backspace Button
                            Button(action: deleteDigit) {
                                Image(systemName: "delete.left")
                                    .font(.title)
                                    .frame(width: 60, height: 60)
                                    .background(Circle().fill(Color.gray.opacity(0.3)))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Navigation Link to next screen
                    NavigationLink(destination: AdminScreen(), isActive: $navigateToNextScreen) {
                        EmptyView()
                    }
                }
                .padding()
            }
            
        }
    }

    private func addDigit(_ digit: Int) {
        if pin.count < maxDigits {
            pin.append(digit)

            if pin.count == maxDigits {
                verifyPin()
            }
        }
    }

    private func deleteDigit() {
        if !pin.isEmpty {
            pin.removeLast()
        }
    }

    private func verifyPin() {
        if pin == adminPin {
            navigateToNextScreen = true
        } else {
            showError = true
            pin.removeAll() // Clear the entered PIN
        }
    }
}

struct PinButton: View {
    let number: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.title)
                .frame(width: 60, height: 60)
                .background(Circle().fill(Color.blue.opacity(0.3)))
        }
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Access Granted!")
            .font(.largeTitle)
            .foregroundColor(.green)
    }
}

#Preview {
    AdminVerificationSheetView()
}

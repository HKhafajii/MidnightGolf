import SwiftUI

struct AdminVerificationSheetView: View {
    @State private var pin: [Int] = []
    let adminPin = [3, 2, 9, 8]
    let maxDigits = 4
    @State private var showError = false
    @Binding  var navigateToNextScreen: Bool
    @Binding var showAdminSheet: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("bg")
                
                VStack {
                    Image(systemName: "chevron.down")
                        .imageScale(.large)
                        .foregroundStyle(Color("blue"))
                    Spacer()
                    
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
                    
                    VStack(spacing: 10) {
                        
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
                        
                        HStack(spacing: 10) {
                            
                            Spacer()
                                .frame(width: 60)
                            
                            
                            PinButton(number: 0) {
                                addDigit(0)
                            }
                            
                            Button(action: deleteDigit) {
                                Image(systemName: "delete.left")
                                    .font(.title)
                                    .frame(width: 60, height: 60)
                                    .background(Circle().fill(Color.gray.opacity(0.3)))
                            }
                        }
                    }
                    
                    Spacer()
                    
                   
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
            showAdminSheet = false
            
        } else {
            showError = true
            pin.removeAll()
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
    AdminVerificationSheetView(navigateToNextScreen: .constant(false), showAdminSheet: .constant(true))
}

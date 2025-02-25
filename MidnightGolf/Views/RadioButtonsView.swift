import SwiftUI

struct Gender: Identifiable {
    let id = UUID()
    let genderType: String
}

struct RadioButtonsView: View {
    @Binding var isMale: Bool
    
    private let genders: [Gender] = [
        Gender(genderType: "Male"),
        Gender(genderType: "Female")
    ]
    
    var body: some View {
        HStack {
            ForEach(genders) { gender in
                RadioButtons(gender: gender, isMale: $isMale)
            }
        }
    }
}

struct RadioButtons: View {
    let gender: Gender
    @Binding var isMale: Bool
    
    let brandColor: Color = Color(red: 28/255, green: 35/255, blue: 40/255)
    
    var isSelected: Bool {
        gender.genderType == "Male" ? isMale : !isMale
    }
    
    var body: some View {
        Button {
         
            if gender.genderType == "Male" {
                isMale = true
            } else {
                isMale = false
            }
        } label: {
            Text(gender.genderType)
                .font(.title2)
                .frame(width: 100, height: 50)
                .padding(2)
                .background(RoundedRectangle(cornerRadius: 8).fill(brandColor))
                .foregroundStyle(isSelected ? .orange : .white)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.orange : Color.white, lineWidth: 3)
                }
        }
    }
}

struct RadioButtonsView_Previews: PreviewProvider {
    struct Container: View {
        @State var isMale: Bool = true
        var body: some View {
            RadioButtonsView(isMale: $isMale)
        }
    }
    static var previews: some View {
        Container()
    }
}

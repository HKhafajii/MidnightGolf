//
//  RadioButtonsView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 2/25/25.
//

import SwiftUI
struct Gender: Identifiable {
    let id = UUID()
    let genderType: String
}

struct RadioButtonsView: View {
    @State var genders: [Gender] = [
        Gender(genderType: "Male"),
        Gender(genderType: "Female")
    ]

    @State var gendersSelected: Gender?

    var body: some View {
        HStack {
            ForEach(genders) { gender in
                RadioButtons(gender: gender, seasonSelected: $gendersSelected)
            }
        }
    }
}

struct RadioButtons: View {
    let gender: Gender
    @Binding var seasonSelected: Gender?

    let brandColor: Color = Color(red: 28/255, green: 35/255, blue: 40/255)

    var isPressed: Bool {
        if let seasonSelected {
            if seasonSelected.id == gender.id { return true }
        }
        return false
    }

    var body: some View {
        Button {
            seasonSelected = gender
        } label: {
            Text("\(gender.genderType)")
        }
        .font(.title2)
        .frame(width: 100, height: 50)
        .padding(2)
        .background(RoundedRectangle(cornerRadius: 8)
            .fill(brandColor)
        )
        .foregroundStyle(isPressed ? .orange : .white)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isPressed ? Color.orange : Color.white, lineWidth: 3)
        }
    }
}

#Preview(body: {
    RadioButtonsView()
})





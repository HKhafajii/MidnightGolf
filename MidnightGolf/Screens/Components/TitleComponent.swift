//
//  TitleComponent.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 3/18/25.
//

import SwiftUI

struct TitleComponent: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title)
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .frame(maxWidth: CheckInScreen.deviceWidth / 2.5,
                   maxHeight: CheckInScreen.deviceHeight * 0.05)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color("MGPnavy")))
            .shadow(radius: 8, x: 0, y: 0)
    }
}


//
//  StudentProfileView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 2/27/25.
//

import SwiftUI

struct StudentProfileView: View {
    let student: Student
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(student.first) \(student.last)")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Divider()
            
            Group {
                InfoRow(label: "School", value: student.school)
                InfoRow(label: "Graduation", value: student.gradDate)
                InfoRow(label: "Email", value: student.email)
                InfoRow(label: "Phone", value: student.cellNumber)
                InfoRow(label: "Date of Birth", value: student.born)
            }
            
            Spacer()
            
            if !student.qrCode.isEmpty {
                Text("Student QR Code")
                    .font(.headline)
                    .padding(.top)
                
                if let qrImage = decodeBase64QRCode(student.qrCode) {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } else {
                    Text("QR Code not available")
                        .foregroundColor(.secondary)
                }
            }
        }
      
    }
    
    private func decodeBase64QRCode(_ base64String: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: data)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 90, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

#Preview {
    StudentProfileView(student: Student(id: "234", group: "234", first: "234", last: "234", born: "234", isMale: true, cellNumber: "asdas", email: "asdasd", cohort: false, school: "asd", gradDate: "asd", qrCode: "asd"))
}

struct ProfileImage: View {
    
    let student: Student
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
        }
    }
}


struct ProfileSection: View {
    let first: String
    let second: String
    var body: some View {
        HStack {
            Text(first)
                .font(.title2)
                .fontWeight(.semibold)

            Text(second)
                .font(.title2)
        }
    }
}

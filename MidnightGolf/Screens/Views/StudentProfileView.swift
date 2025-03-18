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
        VStack(alignment: .leading, spacing: 15) {
            
            ProfileImage(student: student)
            
            ProfileSection(first: "School:", second: student.school)
            
            ProfileSection(first: "Graduation Date:", second: student.gradDate)
            
            ProfileSection(first: "Mobile Phone:", second: student.cellNumber)
            
            ProfileSection(first: "Birthdate:", second: student.born)
            
            ProfileSection(first: "Cohort:", second: student.cohort ? "Mon/Wed" : "Tue/Thu")
          
            ProfileSection(first: "Email:", second: student.email)
            
        }
        .padding()
        
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

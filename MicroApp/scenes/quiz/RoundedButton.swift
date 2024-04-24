//
//  RoundedButton.swift
//  QuizApp
//
//  Created by Tosun, Irem on 26.10.2023.
//

import SwiftUI

struct RoundedButton: View {
    let title: String
    let onclick: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .stroke(Color.blue, lineWidth: 1)
            .frame(height: Constants.Heights.small)
            .contentShape(Rectangle())
            .overlay {
                Text(title)
                    .font(.title2)
                    .padding(.horizontal, 0)
            }
            .onTapGesture {
                onclick()
            }
    }
}

#Preview {
    RoundedButton(title: "test") {
        print("ok")
    }
}

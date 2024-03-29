//
//  NumberButton.swift
//  app
//
//  Created by Kai Mayer on 28.03.24.
//

import SwiftUI

struct NumberButton: View {
    @Binding var number: String
    
    let char: Character
    let text: String?
    
    init(_ char: Character, number: Binding<String>, text: String? = nil) {
        self.char = char
        self.text = text
        self._number = number
    }
    
    var body: some View {
        Button {
            number.append(char)
        } label: {
            VStack {
                Text(String(char))
                    .font(.title)
                if let text = text {
                    Text(text)
                        .font(.caption2)
                }
            }
            .frame(width: 75, height: 75)
            .foregroundColor(Color(UIColor.label))
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    @State var number: String = ""
    
    return NumberButton("1", number: $number, text: "A B C")
}

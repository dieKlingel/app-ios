//
//  Dialpad.swift
//  app
//
//  Created by Kai Mayer on 28.03.24.
//

import SwiftUI

struct Keypad: View {
    @State var number = ""
    let dial: (String) -> Void
    
    var body: some View {
        NavigationStack {
            Spacer()
            TextField("Number", text: $number)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .multilineTextAlignment(.center)
            Spacer()
            Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                GridRow {
                    NumberButton("1", number: $number, text: "")
                    NumberButton("2", number: $number, text: "A B C")
                    NumberButton("3", number: $number, text: "D E F")
                }
                GridRow {
                    NumberButton("4", number: $number, text: "G H I")
                    NumberButton("5", number: $number, text: "J K L")
                    NumberButton("6", number: $number, text: "M N O")
                }
                GridRow {
                    NumberButton("7", number: $number, text: "P Q R S")
                    NumberButton("8", number: $number, text: "T U V")
                    NumberButton("9", number: $number, text: "W X Y Z")
                }
                GridRow {
                    NumberButton("*", number: $number)
                    NumberButton("0", number: $number, text: "+")
                    NumberButton("#", number: $number)
                }
                GridRow {
                    Rectangle()
                        .frame(width: 0, height: 0)
                    
                    Button {
                        dial(number)
                        number = ""
                    } label: {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .padding(25)
                            .frame(width: 75, height: 75)
                            .foregroundColor(.white)
                            .background(.green)
                            .clipShape(.circle)
                    }
                    
                    if(!number.isEmpty) {
                        Button {
                            number = String(number.dropLast())
                        } label: {
                            Image(systemName: "delete.backward.fill")
                                .resizable()
                                .foregroundStyle(
                                    Color(UIColor.label),
                                    Color(UIColor.secondarySystemBackground)
                                )
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                                .frame(width: 75, height: 75)
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    return Keypad() { number in
            
    }
}

//
//  Dial.swift
//  app
//
//  Created by Kai Mayer on 29.03.24.
//

import SwiftUI

struct KeypadTab: View {
    @Environment(HomeViewModel.self) private var vm
    
    var body: some View {
        NavigationStack {
            Keypad() { number in
                vm.invite(uri: number)
            }
        }
    }
}

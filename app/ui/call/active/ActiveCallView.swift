//
//  ActiveCallView.swift
//  app
//
//  Created by Kai Mayer on 24.03.24.
//

import SwiftUI
import linphonesw

struct ActiveCallView: View {
    @State var call: Call
    
    init(call: Call) {
        self.call = call
    }
    
    var body: some View {
        ZStack {
            VideoView(call: $call)
                .aspectRatio(640 / 480 ,contentMode: .fit)
                .ignoresSafeArea(.all)
        }
    }
}

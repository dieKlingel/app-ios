//
//  VideoView.swift
//  app
//
//  Created by Kai Mayer on 24.03.24.
//

import SwiftUI
import linphonesw

struct VideoView: UIViewRepresentable {
    @Binding var call: Call

    func makeUIView(context: Context) -> UIView {
        UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 640,
                height: 480
            )
        )
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        call.core!.nativeVideoWindow = uiView;
    }
}

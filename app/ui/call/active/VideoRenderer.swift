import SwiftUI
import linphonesw

struct VideoRenderer: UIViewRepresentable {
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

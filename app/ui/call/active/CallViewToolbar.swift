import SwiftUI
import linphonesw

struct CallViewToolbar: View {
    let hangup: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                hangup()
            } label: {
                Image(systemName: "phone.down.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 20)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.red)
                    .clipShape(.capsule)
            }
           
            // TODO: add microphone and speaker button
            /*
            Button {
                
            } label: {
                Image(systemName: "mic.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 20)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.green)
                    .clipShape(.capsule)
            }
            
            Button {
                
            } label: {
                Image(systemName: "speaker.wave.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 20)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.green)
                    .clipShape(.capsule)
            }
             */
        }
    }
}

#Preview {
    CallViewToolbar {
    }
}

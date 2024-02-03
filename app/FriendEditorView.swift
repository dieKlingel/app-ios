import SwiftUI

struct FriendEditorView : View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @ObservedObject var app: AppState
    
    @State var name = ""
    @State var address = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("name", text: $name)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                Section(header: Text("Address")) {
                    TextField("sip address", text: $address)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("Device")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        let friend = Friend(name: name, address: address)
                        context.insert(friend)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(name.isEmpty || address.isEmpty)
                }
            }
        }
    }
}

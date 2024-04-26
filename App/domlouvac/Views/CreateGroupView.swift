import SwiftUI

struct CreateGroupView: View {
    @State private var groupName: String = "";
    
    var body: some View {
        VStack {
            Text("Create New Group")
                .font(.title)
                .fontWeight(.semibold)
            
                VStack(alignment: .leading) {
                    Text("Group Name").padding(.horizontal).fontWeight(.semibold)
                    
                    TextField("My New Group", text: $groupName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }.padding()
            
            Spacer()
            
            Button() {
                
            } label: {
                Text("Create Group")
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding()
        }
    }
}

#Preview {
    CreateGroupView()
}

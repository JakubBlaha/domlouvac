import SwiftUI

struct CreateGroupView: View {
    @EnvironmentObject var environ: EnvironModel
    @ObservedObject var model = CreateGroupViewModel()

    var body: some View {
        VStack {
            Text("Create New Group")
                .font(.title)
                .fontWeight(.semibold)

            VStack(alignment: .leading) {
                Text("Group Name").padding(.horizontal).fontWeight(.semibold)

                TextField("My New Group", text: $model.groupName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }.padding()

            Spacer()

            Button {
                Task {
                    await model.createGroup(auth: environ.tokenAuth)
                }
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

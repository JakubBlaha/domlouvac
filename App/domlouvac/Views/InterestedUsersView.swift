import SwiftUI

struct InterestedUsersView: View {
    @State var users: [UserModel]

    var body: some View {
        List(users) { user in
            UserListItemView(user: user)
        }.navigationTitle("Interested people")
    }
}

#Preview {
    InterestedUsersView(users: [UserModel(id: UUID(), name: "John Doe"), UserModel(id: UUID(), name: "John Doe")])
}

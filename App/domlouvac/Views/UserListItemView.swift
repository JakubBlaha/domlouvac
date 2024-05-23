import SwiftUI

struct UserListItemView: View {
    var user: UserModel

    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
            Text(user.name)
            Spacer()
        }.frame(height: 40)
    }
}

#Preview {
    UserListItemView(user: UserModel(id: UUID(), name: "John Doe"))
}

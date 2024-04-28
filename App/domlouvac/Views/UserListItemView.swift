import SwiftUI

struct UserListItemView: View {
    var user: UserPublic

    init(user: UserPublic) {
        self.user = user
    }

    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
            Text(user.name)
            Spacer()
        }.frame(height: 40)
    }
}

#Preview {
    UserListItemView(user: UserPublic(id: UUID(), name: "John Doe"))
}

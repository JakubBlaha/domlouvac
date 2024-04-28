import SwiftUI

struct GroupDetailView: View {
    @ObservedObject var model: GroupViewDetailModel

    init(group: GroupListModel) {
        model = GroupViewDetailModel(group: group)
    }

    var body: some View {
        VStack {
            HStack {
                Text(model.group.name).font(.system(size: 64)).fontWeight(.bold).foregroundColor(.white)
                Spacer()
            }.padding().background {
                Color(.systemBlue)
            }

            HStack {
                Text("Users").fontWeight(.semibold).font(.title3)
                Spacer()
            }.padding()

            List(model.group.users) { user in
                UserListItemView(user: user)
            }

            Spacer()
        }
    }
}

#Preview {
    GroupDetailView(group: GroupListModel(id: UUID(), code: "123123", name: "Preview Group", users: [
        UserPublic(id: UUID(), name: "John Doe"),
        UserPublic(id: UUID(), name: "John Doe"),
    ]))
}

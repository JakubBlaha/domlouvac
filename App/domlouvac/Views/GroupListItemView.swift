import SwiftUI

struct GroupListItemView: View {
    var group: GroupListModel

    init(group: GroupListModel) {
        self.group = group
    }

    var body: some View {
        Text(self.group.name)
    }
}

#Preview {
    GroupListItemView(group: GroupListModel(id: UUID(), code: "123123", name: "Preview Group", users: []))
}

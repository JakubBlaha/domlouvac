import SwiftUI

struct GroupListItemView: View {
    var group: Group

    init(group: Group) {
        self.group = group
    }

    var body: some View {
        Text(self.group.name)
    }
}

#Preview {
    GroupListItemView(group: Group(id: UUID(), code: "123123", name: "Preview Group"))
}

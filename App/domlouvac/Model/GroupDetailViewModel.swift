import Foundation

class GroupViewDetailModel: ObservableObject {
    @Published var group: GroupListModel

    init(group: GroupListModel) {
        self.group = group
    }
}

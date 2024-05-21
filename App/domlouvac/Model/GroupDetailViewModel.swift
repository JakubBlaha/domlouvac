import Foundation

class GroupViewDetailModel: ObservableObject {
    @Published var group: GroupListModel
    @Published var isSuccess: Bool = false

    init(group: GroupListModel) {
        self.group = group
    }

    func leaveGroup(auth: Authorization) async {
        print(auth)

        do {
            try await HttpClient.shared.sendReqest(to: "groups/leave/" + group.id.uuidString, httpMethod: HttpMethod.POST.rawValue, auth: auth)
        } catch {
            print(error)
            return
        }

        DispatchQueue.main.async {
            self.isSuccess = true
        }
    }
}

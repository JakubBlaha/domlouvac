import Foundation

class GroupViewDetailModel: ObservableObject {
    @Published var group: GroupListModel
    @Published var isSuccess: Bool = false
    @Published var isRefreshingEvents = false
    @Published var events: [Event] = []

    init(group: GroupListModel) {
        self.group = group
    }

    func leaveGroup(auth: Authorization) async {
        do {
            try await HttpClient.shared.sendReqest(to: "groups/leave/" + group.id.uuidString, httpMethod: HttpMethod.POST.rawValue, auth: auth)
        } catch {
            print(error)
            return
        }

        await MainActor.run {
            self.isSuccess = true
        }
    }

    func refreshEvents(auth: Authorization) async {
        await MainActor.run {
            isRefreshingEvents = true
        }

        defer {
            Task { @MainActor in
                isRefreshingEvents = false
            }
        }

        guard let events_: [Event] = try? await HttpClient.shared.fetch(endpoint: "groups/\(group.id)/events", auth: auth) else {
            return
        }

        await MainActor.run {
            events = events_
        }
    }
}

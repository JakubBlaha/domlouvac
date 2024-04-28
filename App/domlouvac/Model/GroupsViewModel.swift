import Foundation

class GroupsViewModel: ObservableObject {
    @Published var myGroups: [GroupListModel]
    @Published var isError = false
    @Published var isFetching = true

    init() {
        myGroups = []
    }

    func fetchMyGroups(auth: Authorization) async {
        await MainActor.run {
            isFetching = true
        }

        defer {
            Task { @MainActor in
                isFetching = false
            }
        }

        guard let groups: [GroupListModel] = try? await HttpClient.shared.fetch(
            endpoint: "groups",
            auth: auth
        ) else {
            await MainActor.run {
                isError = true
            }

            return
        }

        await MainActor.run {
            myGroups = groups
        }
    }
}

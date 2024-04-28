import Foundation

class GroupsViewModel: ObservableObject {
    @Published var myGroups: [Group]
    @Published var isError = false
    @Published var isFetching = true

    init() {
        myGroups = []
    }

    func fetchMyGroups() async {
        await MainActor.run {
            isFetching = true
        }

        defer {
            Task { @MainActor in
                isFetching = false
            }
        }

        guard let groups: [Group] = try? await HttpClient.shared.fetch(urlSegment: "groups") else {
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

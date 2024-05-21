import SwiftUI

class JoinGroupViewModel: ObservableObject {
    @Published var groupId: String = ""
    @Published var isJoining: Bool = false
    @Published var isSuccess: Bool = false

    func joinGroup(auth: Authorization) async {
        print(auth)

        do {
            try await HttpClient.shared.sendReqest(to: "groups/join/" + groupId, httpMethod: HttpMethod.POST.rawValue, auth: auth)
        } catch {
            print(error)
            return
        }

        DispatchQueue.main.async {
            self.isSuccess = true
        }
    }
}

import Foundation

class CreateGroupViewModel: ObservableObject, Encodable {
    @Published var groupName: String = ""

    private enum CodingKeys: String, CodingKey {
        case name
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(groupName, forKey: .name)
    }

    func createGroup(auth: Authorization) async {
        print(auth)

        do {
            try await HttpClient.shared.sendData(
                toEndpoint: "groups",
                object: self,
                httpMethod: HttpMethod.POST,
                authorization: auth
            )
        } catch {
            print(error)
        }
    }
}

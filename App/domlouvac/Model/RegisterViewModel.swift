import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject, Encodable {
    @Published var name: String
    @Published var email: String
    @Published var password: String

    @Published var isRegistering: Bool = false
    @Published var isSuccess: Bool = false
    @Published var isError: Bool = false

    init() {
        name = ""
        email = ""
        password = ""
    }

    private enum CodingKeys: String, CodingKey {
        case name, email, password
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }

    func register() async {
        await MainActor.run {
            isRegistering = true
        }

        do {
            try await HttpClient.shared.sendData(toEndpoint: "users", object: self, httpMethod: HttpMethod.POST)
        } catch {
            await MainActor.run {
                isError = true
                isRegistering = false
            }
            return
        }

        await MainActor.run {
            isSuccess = true
        }
    }
}

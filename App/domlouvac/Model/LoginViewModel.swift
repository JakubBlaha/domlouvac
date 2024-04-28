import Foundation
import SwiftUI

class LoginViewModel: ObservableObject, Encodable {
    @Published var email: String
    @Published var password: String

    @Published var isLoggingIn: Bool = false
    @Published var isSuccess: Bool = false
    @Published var isError: Bool = false

    init() {
        email = ""
        password = ""
    }

    private enum CodingKeys: String, CodingKey {
        case email, password
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    }

    func login() async {
        await MainActor.run {
            isLoggingIn = true
        }

        let authorization = Authorization(username: email, password: password)

        var loginRes: LoginRes

        do {
            loginRes = try await HttpClient.shared.sendData(
                endpoint: "login", object: self, httpMethod: HttpMethod.POST, auth: authorization)

            try KeychainWrapper.shared.storeAccessToken(token: loginRes.value)
        } catch {
            await MainActor.run {
                isError = true
                isLoggingIn = false
            }
            return
        }

        print("Logged in")

        let saved = KeychainWrapper.shared.getAccessToken()

        print("saved")
        print(saved)

        await MainActor.run {
            isSuccess = true
            isLoggingIn = false
        }
    }
}

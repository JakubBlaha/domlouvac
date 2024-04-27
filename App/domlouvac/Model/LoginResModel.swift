import Foundation

struct LoginRes: Decodable {
    let id: String
    let value: String
    let user: User

    struct User: Decodable {
        let id: String
    }
}

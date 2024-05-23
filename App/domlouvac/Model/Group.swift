import Foundation

struct Group: Hashable, Codable, Identifiable {
    var id: UUID
    var code: String
    var name: String
}

struct GroupListModel: Hashable, Decodable, Identifiable {
    var id: UUID
    var code: String
    var name: String

    var users: [UserModel]
}

import Fluent
import Vapor

final class UserGroup: Model {
    static let schema = "user+group"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "group_id")
    var group: Group

    init() {}

    init(id: UUID? = nil, user: User, group: Group) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.$group.id = try group.requireID()
    }
}

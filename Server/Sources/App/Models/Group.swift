import Fluent
import Vapor

final class Group: Model, Content {
    static let schema = "groups"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "code")
    var code: String

    @Field(key: "name")
    var name: String

    @Siblings(through: UserGroup.self, from: \.$group, to: \.$user)
    public var users: [User]

    init() {}

    init(id: UUID? = nil, code: String, name: String) {
        self.id = id
        self.name = name
        self.code = code
    }

    static func findWithUsers(_ groupId: UUID, on: any Database) async throws -> Group? {
        let group = try await self.query(on: on).filter(\.$id == groupId).with(\.$users)
            .first()

        return group
    }
}

extension Group {
    struct Create: Content, Validatable {
        var name: String

        static func validations(_ validations: inout Validations) {
            validations.add("name", as: String.self, is: !.empty)
        }
    }
}

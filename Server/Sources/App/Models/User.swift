import Fluent
import Vapor

final class User: Model, Content, HasId {
    static let schema: String = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Siblings(through: UserGroup.self, from: \.$user, to: \.$group)
    public var groups: [Group]

    @Siblings(through: UserEvent.self, from: \.$user, to: \.$event)
    public var events: [Event]

    init() {}

    init(id: UUID? = nil, name: String, email: String, passwordHash: String) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
    }

    func loadGroups(on: any Database) async throws {
        try await self.$groups.load(on: on)
    }
}

extension User {
    struct Create: Content, Validatable {
        var name: String
        var email: String
        var password: String

        static func validations(_ validations: inout Validations) {
            validations.add("name", as: String.self, is: !.empty)
            validations.add("email", as: String.self, is: .email)
            validations.add("password", as: String.self, is: .count(8...))
        }
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.post("users") { req async throws -> User in
        try User.Create.validate(content: req)

        let create = try req.content.decode(User.Create.self)
        let user = try User(
            name: create.name,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )
        try await user.save(on: req.db)
        return user
    }

    let passwordProtected = app.grouped(User.authenticator())
    passwordProtected.post("login") { req -> UserToken in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()

        try await token.save(on: req.db)

        return token
    }

    try app.register(collection: GroupController())
    try app.register(collection: EventController())
}

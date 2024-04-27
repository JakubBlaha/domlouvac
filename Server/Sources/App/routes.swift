import Fluent
import Vapor

func routes(_ app: Application) throws {
    // app.get { req async in
    //     "It works!"
    // }

    // app.get("hello") { req async -> String in
    //     "Hello, world!"
    // }

    // let protected = app.grouped(User.authenticator())

    // protected.get("me") { req -> String in
    //     try req.auth.require(User.self).name
    // }

    let passwordProtected = app.grouped(User.authenticator())
    passwordProtected.post("login") { req -> UserToken in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()

        try await token.save(on: req.db)

        return token
    }

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

    try app.register(collection: TodoController())
}

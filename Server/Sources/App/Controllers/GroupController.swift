import Fluent
import Vapor

struct GroupController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.grouped(UserToken.authenticator())
        let groups = tokenProtected.grouped("groups")

        groups.get(use: { try await self.index(req: $0) })
        groups.post(use: { try await self.create(req: $0) })
        groups.group(":groupCode") { group in
            group.delete(use: { try await self.delete(req: $0) })
        }
    }

    func index(req: Request) async throws -> [Group] {
        try await Group.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Group {
        try req.auth.require(User.self)

        try Group.Create.validate(content: req)
        let create = try req.content.decode(Group.Create.self)

        let newCode = String(format: "%06d", Int.random(in: 0...999_999))

        let group = Group(
            code: newCode,
            name: create.name
        )

        try await group.save(on: req.db)

        return group
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let groupCode = req.parameters.get("groupCode") else {
            throw Abort(.badRequest)
        }

        guard let group = try await Group.query(on: req.db).filter(\.$code == groupCode).first()
        else {
            throw Abort(.notFound)
        }

        try await group.delete(on: req.db)
        return .noContent
    }
}

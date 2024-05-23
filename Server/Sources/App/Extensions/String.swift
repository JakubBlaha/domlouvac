import Fluent

extension Optional where Wrapped == String {
    func toUUID() -> UUID? {
        guard let string = self else { return nil }
        return UUID(uuidString: string)
    }
}

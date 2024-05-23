extension Array where Element: HasId {
    func hasId(_ id: Element.ID_) -> Bool {
        self.contains(where: { $0.id == id })
    }
}

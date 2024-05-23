protocol HasId {
    associatedtype ID_: Equatable
    var id: ID_ { get }
}

import Foundation

class BoolSwitch: ObservableObject {
    @Published var val = false

    func set() {
        Task { @MainActor in
            val = true
        }
    }

    func reset() {
        Task { @MainActor in
            val = false
        }
    }
}

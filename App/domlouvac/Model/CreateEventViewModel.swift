import Combine
import Foundation
import SwiftUI

class CreateEventViewModel: ObservableObject, Encodable {
    @Published var eventTitle: String = ""
    @Published var eventLocation: String = ""
    @Published var eventStartDate: Date = Date.now
    @Published var eventDurationEnumValue: EventDuration = .HOURS_1
    @Published var selectedImage: UIImage? = nil
    @Published var base64EncodedImage: String? = nil

    @Published var inputValid = false
    @Published var isCreatingEvent = false
    @Published var isSuccess = false

    var groupId: UUID?

    var kombajn: AnyCancellable?

    private enum CodingKeys: String, CodingKey {
        case title, location, startTime, durationSeconds, groupId, base64image
    }

    init() {
        kombajn = $eventTitle.combineLatest($eventLocation, $base64EncodedImage).sink { title, location, base64EncodedImage in
            if !title.isEmpty && !location.isEmpty && base64EncodedImage != nil {
                self.inputValid = true
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventTitle, forKey: .title)
        try container.encode(eventLocation, forKey: .location)
        try container.encode(groupId!.uuidString, forKey: .groupId)
        try container.encode(eventStartDate, forKey: .startTime)
        try container.encode(eventDurationEnumValue.value.seconds, forKey: .durationSeconds)
        try container.encode(base64EncodedImage, forKey: .base64image)
    }

    func createEvent(auth: Authorization, groupId: UUID) async {
        self.groupId = groupId

        print(auth)

        DispatchQueue.main.async { [weak self] in
            self?.isCreatingEvent = true
        }

        defer {
            DispatchQueue.main.async {
                self.isCreatingEvent = false
            }
        }

        do {
            try await HttpClient.shared.sendData(
                toEndpoint: "groups/\(groupId.uuidString)/events",
                object: self,
                httpMethod: HttpMethod.POST,
                authorization: auth
            )
        } catch {
            print(error)
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.isSuccess = true
        }
    }
}

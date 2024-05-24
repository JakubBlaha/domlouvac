import SwiftUI

struct EventList: View {
    var events: [Event]

    var body: some View {
        if events.isEmpty {
            Text("No events to show.")
                .fontWeight(.medium)
                .foregroundColor(.gray)
        } else {
            List(events, id: \.self.id) { event in
                ZStack {
                    EventPreview(event: event)
                        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))

                    NavigationLink {
                        EventDetailView(model: EventDetailViewModel(event: event))
                    } label: {}.opacity(0)
                }
            }
            .listStyle(.plain)
        }
    }

    func refresh() {
    }
}

#Preview {
    EventList(events: [exampleEvent, exampleEvent])
}

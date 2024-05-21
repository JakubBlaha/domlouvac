import SwiftUI

struct EventList: View {
    var body: some View {
        List(events, id: \.self.id) { event in
            ZStack {
                EventPreview(event: event)
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))

                NavigationLink {
                    EventDetailView(event: event)
                } label: {}.opacity(0)
            }
        }
        .listStyle(.plain)
    }

    func refresh() {
    }
}

#Preview {
    EventList()
}

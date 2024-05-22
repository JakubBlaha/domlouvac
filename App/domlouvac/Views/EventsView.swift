import SwiftUI

struct EventsView: View {
    @EnvironmentObject var environ: EnvironModel
    @ObservedObject var model = EventsViewModel()

    var body: some View {
        NavigationView {
            EventList(events: model.events)
                .navigationTitle("Events")
        }
        .onAppear(perform: refresh)
    }

    func refresh() {
        Task {
            await model.refreshEvents(auth: environ.tokenAuth)
        }
    }
}

#Preview {
    EventsView()
}

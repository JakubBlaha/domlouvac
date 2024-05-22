import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            EventList(events: [exampleEvent, exampleEvent, exampleEvent])
                .navigationTitle("Events")
        }
    }
}

#Preview {
    HomeView()
}

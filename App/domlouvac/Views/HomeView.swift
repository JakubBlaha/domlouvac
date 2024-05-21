import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            EventList()
                .navigationTitle("Events")
        }
    }
}

#Preview {
    HomeView()
}

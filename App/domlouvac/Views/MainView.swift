import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            GroupsView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                }
            EventsView()
                .tabItem {
                    Image(systemName: "calendar")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    MainView()
}

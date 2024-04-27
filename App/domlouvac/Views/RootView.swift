import SwiftUI

struct RootView: View {
    @ObservedObject var environ = EnvironModel()

    var body: some View {
        if environ.accessToken != nil {
            MainView().environmentObject(environ)
        } else {
            WelcomeView().environmentObject(environ)
        }
    }
}

#Preview {
    RootView()
}

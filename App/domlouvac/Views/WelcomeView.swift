import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {

            VStack {
                HStack {
                    Text("Welcome to domlouvac!")
                        .padding()
                        .font(.system(size: 56))
                        .fontWeight(.bold)

                    Spacer()
                }

                HStack {
                    // Register button
                    NavigationLink(
                        destination: RegisterView(),
                        label: {
                            Text("Register")
                                .frame(maxHeight: .infinity)
                                .frame(maxWidth: .infinity)
                        }
                    ).buttonStyle(.bordered)

                    // Login button
                    NavigationLink(
                        destination: LoginView(),
                        label: {
                            Text("Login")
                                .frame(maxHeight: .infinity)
                                .frame(maxWidth: .infinity)
                        }
                    ).buttonStyle(.bordered)
                }.frame(maxHeight: 60).padding(.horizontal)

                Spacer()
            }.padding(.top, 120)
        }
    }
}

#Preview {
    WelcomeView()
}

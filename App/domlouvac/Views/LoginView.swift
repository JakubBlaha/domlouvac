import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    private var emailPlaceholder = "john.doe@example.com"

    var body: some View {
        VStack {
            HStack {
                Text("Login")
                    .padding()
                    .font(.system(size: 56))
                    .fontWeight(.bold)

                Spacer()
            }

            VStack(alignment: .leading) {
                // Email
                Text("Email").padding(.horizontal).fontWeight(.semibold)

                TextField(emailPlaceholder, text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // Password
                Text("Password").padding(.horizontal).fontWeight(.semibold)

                SecureField("********", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }.padding()

            Spacer()

            Button {
                handleLogin()
            } label: {
                Text("Login")
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxHeight: 60)
            .padding()
            .fontWeight(.semibold)

        }.padding(.top, 120)

    }

    func handleLogin() {

    }
}

#Preview {
    LoginView()
}

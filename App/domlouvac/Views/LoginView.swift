import SwiftUI

struct LoginView: View {
    @EnvironmentObject var environ: EnvironModel
    @ObservedObject var model = LoginViewModel()

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

                TextField(emailPlaceholder, text: $model.email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // Password
                Text("Password").padding(.horizontal).fontWeight(.semibold)

                SecureField("********", text: $model.password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }.padding()

            if model.isError {
                Text("There was an error while registering!").foregroundColor(.red)
            }

            Spacer()

            Button {
                Task {
                    await model.login()
                    environ.accessToken = KeychainWrapper.shared.getAccessToken()
                }
            } label: {
                HStack {
                    if model.isLoggingIn {
                        ProgressView().colorInvert().padding(.trailing, 4)
                    }

                    Text("Login")
                        .frame(maxHeight: .infinity)
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxHeight: 60)
            .padding()
            .fontWeight(.semibold)
            .disabled(model.isLoggingIn)

        }.padding(.top, 120)
    }
}

#Preview {
    LoginView()
}

import SwiftUI

struct RegisterView: View {
    @ObservedObject var model = RegisterViewModel()

    @Environment(\.dismiss) private var dismiss

    private var emailPlaceholder = "john.doe@example.com"

    var body: some View {
        VStack {
            HStack {
                Text("Register")
                    .padding()
                    .font(.system(size: 56))
                    .fontWeight(.bold)

                Spacer()
            }

            VStack(alignment: .leading) {
                // Name
                Text("Name").padding(.horizontal).fontWeight(.semibold)

                TextField("John Doe", text: $model.name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

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
                    await model.register()

                    if model.isSuccess {
                        try await Task.sleep(nanoseconds: 2 * 1000000000)

                        dismiss()
                    }
                }
            } label: {
                HStack {
                    if model.isRegistering {
                        ProgressView().colorInvert().padding(.trailing, 4)
                    }

                    Text("Register")
                        .frame(maxHeight: .infinity)

                    if model.isSuccess {
                        Image(systemName: "checkmark")
                    }
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxHeight: 60)
            .padding()
            .fontWeight(.semibold)
            .disabled(model.isRegistering || model.isSuccess)
        }
        .padding(.top, 120)
    }
}

#Preview {
    RegisterView()
}

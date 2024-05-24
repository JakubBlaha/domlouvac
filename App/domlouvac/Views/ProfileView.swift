import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var environ: EnvironModel
    @ObservedObject var model = ProfileViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Button {
                    model.logout()
                    environ.accessToken = nil
                } label: {
                    ZStack {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                            .fontWeight(.semibold)

                        HStack {
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .padding(.trailing)
                        }.frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .padding()
                .navigationTitle("Account")
            }
        }
    }
}

#Preview {
    ProfileView()
}

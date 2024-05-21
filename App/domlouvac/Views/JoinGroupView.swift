import Foundation
import SwiftUI

struct JoinGroupView: View {
    @ObservedObject var model = JoinGroupViewModel()
    @EnvironmentObject var environ: EnvironModel
    @Environment(\.dismiss) private var dismiss

    var groupIdValid: Bool {
        return Int(model.groupId) != nil && model.groupId.count == 6
    }

    var body: some View {
        VStack {
            Spacer()

            Text("Join Group").font(.title).fontWeight(.semibold)

            TextField("\(Image(systemName: "square.and.pencil")) Group ID", text: $model.groupId)
                .padding()
                .font(.title)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)

            Text("\(Image(systemName: "exclamationmark.triangle.fill")) Group ID must be a 6 digit number.")
                .font(.footnote)
                .foregroundColor(.blue)
                .opacity(groupIdValid || model.groupId.count == 0 ? 0 : 1)

            Spacer()

            // Join group button
            Button {
                Task {
                    await model.joinGroup(auth: try! environ.tokenAuth)

                    if model.isSuccess {
                        dismiss()
                    }
                }
            } label: {
                HStack {
                    if model.isJoining {
                        ProgressView().colorInvert().padding(.trailing, 4)
                    }

                    Text("Join")
                        .frame(maxHeight: .infinity)
                        .fontWeight(.semibold)

                }.frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding()
            .disabled(model.isJoining || !groupIdValid)
            .alert("Success", isPresented: $model.isSuccess) {
                Text("Continue")
            } message: {
                Text("Successfully joined group!")
            }

        }.padding()
    }
}

#Preview {
    JoinGroupView()
}

import SwiftUI
import Foundation

struct JoinGroupView: View {
    @State private var groupId: String = ""
    @State private var isJoining: Bool = false
    
    var groupIdValid: Bool {
        return Int(groupId) != nil && groupId.count == 6;
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Join Group").font(.title).fontWeight(.semibold)
            
            TextField("\(Image(systemName: "square.and.pencil")) Group ID", text: $groupId)
                .padding()
                .font(.title)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
            
            Text("\(Image(systemName: "exclamationmark.triangle.fill")) Group ID must be a 6 digit number.")
                .font(.footnote)
                .foregroundColor(.blue)
                .opacity(groupIdValid || groupId.count == 0 ? 0 : 1)
            
            Spacer()
            
            Button() {
                Task {
                    await handleJoin()
                }
            } label: {
                HStack {
                    if (isJoining) {
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
            .disabled(isJoining || !groupIdValid)
            
        }.padding()
    }
    
    func handleJoin() async {
        isJoining = true;
        
        do {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000);
        } catch {
            
        }
        
        isJoining = false;
    }
}

#Preview {
    JoinGroupView()
}





import SwiftUI

struct AlertWithoutButton: View {
    @Binding var isActive: Bool
    
    @State var title: String
    @State var message: String
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()
                
                Text(message)
                    .font(.body)
                    .padding(.bottom)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topTrailing) {
                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding()
                }
                .tint(.black)
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    close()
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isActive = false
        }
    }
}

#Preview {
    AlertWithoutButton(isActive: .constant(true), title: "Preview", message: "Ini hanya muncul selama 3 detik")
}

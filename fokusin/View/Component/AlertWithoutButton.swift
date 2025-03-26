import SwiftUI


struct AlertWithoutButton: View {
    @Binding var isActive: Bool
    
    @State var title: String
    @State var message: String
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            // Latar belakang hitam semi-transparan
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { close() }
            
            VStack(spacing: 0) {
                // Telur dan lingkaran
                ZStack {
                    Circle()
                        .fill(Color.tombol)
                        .frame(width: 100, height: 100)
                    
                    Image("TelurUtuh") // Pastikan nama gambar sesuai dengan Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .offset(y: 30)
                .zIndex(1)
                
                // Frame putih dengan teks dan tombol close
                VStack(spacing: 10) {
                    Text(title)
                        .font(.title2)
                        .bold()
                    
                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .frame(width: 300, height: 140)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    // Tombol close di pojok kanan atas
                    Button(action: close) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .padding()
                    }
                    .tint(.black),
                    alignment: .topTrailing
                )
                .shadow(radius: 10)
            }
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring()) { offset = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { close() } // Auto-close dalam 3 detik
            }
        }
    }
    
    private func close() {
        withAnimation(.spring()) { offset = 1000 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { isActive = false }
    }
}


#Preview {
    AlertWithoutButton(isActive: .constant(true), title: "Waktunya Istirahat", message: "Ini hanya muncul selama 3 detik")
}

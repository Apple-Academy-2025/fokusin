//
//  AlertCongrats.swift
//  fokusin
//
//  Created by Abdul Jabbar on 25/03/25.
//

import SwiftUI

struct AlertCongrats: View {
    @Binding var isActive: Bool
    @State var title: String
    @State var message: String
    var difficultyView: String
    var action: () -> Void
    @State private var offset: CGFloat = 1000
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Latar belakang gelap yang menutupi seluruh layar
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all) // ✅ Pastikan menutupi seluruh layar
                .onTapGesture { close() }
            
            VStack {
                ZStack {
                    HStack(spacing: 20) {
                        Button(action: { navigateToStartView() }) {
                            Circle()
                                .fill(Color.tombol)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.title2)
                                        .foregroundColor(.tombol2)
                                        .fontWeight(.bold)
                                )
                        }
                        
                        Button(action: { navigateToMain() }) {
                            Circle()
                                .fill(Color.tombol)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "house")
                                        .font(.title2)
                                        .foregroundColor(.tombol2)
                                        .fontWeight(.bold)
                                )
                        }
                    }
                }
                .offset(y: 365)
                .zIndex(1)
                
                VStack(spacing: 16) {
                    Image(.congratsEgg)
                        .padding(.trailing, 20)
                    
                    Text("CONGRATS!")
                        .font(.title)
                        .bold()
                    
                    Text("You’ve completed a Pomodoro session, Great Job!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding()
                .frame(width: 300, height: 340)
                .background(Color.white) // ✅ Pastikan background tetap putih
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10) // ✅ Full shadow
            }
            .offset(y: offset)
            .onAppear { withAnimation(.spring()) { offset = 0 } }
        }
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            isActive = false
        }
    }
    
    func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    func navigateToStartView() {
        dismiss()
    }
    
    func navigateToMain() {
        if let window = getKeyWindow() {
            window.rootViewController = UIHostingController(rootView:
                NavigationStack {
                    Main()
                        .onAppear {
                            print("✅ Kembali ke Main, memperbarui data history...")
                        }
                }
            )
            window.makeKeyAndVisible()
        }
    }

}

#Preview {
    AlertCongrats(
        isActive: .constant(true),
        title: "Contoh",
        message: "Ini hanya contoh preview",
        difficultyView: "Long"
    ) {
        print("Tombol ditekan!")
    }
}



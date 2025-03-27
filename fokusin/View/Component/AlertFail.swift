//
//  AlertFail.swift
//  fokusin
//
//  Created by Abdul Jabbar on 25/03/25.
//

import SwiftUI

struct AlertFail: View {
    @Binding var isActive: Bool
    @State var title: String
    @State var message: String
    var difficultyView: String
    
    var action: () -> Void
    
    @State private var offset: CGFloat = 1000
    @State private var isAnimating = false
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        ZStack {
            // Background transparan
            Color(.black)
                .opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { close() }
            
            VStack(spacing: 0) {
                // Tombol Repeat dan Home
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
                
                // Frame putih dengan teks dan tombol close
                VStack(spacing: 16) {
                    Image(.failEgg)
                        .resizable()
                        .frame(width: 150, height: 120)
                        .padding(.bottom, 16)
                    
                    Text("OH NO!!")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(red: 211/255, green: 114/255, blue: 114/255))
                        .scaleEffect(isAnimating ? 1.7 : 1.0) // Efek membesar
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0).repeatCount(1, autoreverses: true)) {
                                isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                isAnimating = false
                            }
                        }
                    
                    Text("What a shame, try again next time")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .foregroundColor(.tombol2)
                }
                .padding()
                .frame(width: 300, height: 340)
                .background(.primer)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .overlay(alignment: .topTrailing) {
                    Button(action: { close() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.tombol2)
                    }
                    .tint(.black)
                }
            }
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring()) { offset = 0 }
            }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let window = getKeyWindow() {
                    window.rootViewController = UIHostingController(rootView: ExplanationView(difficulty: difficultyView))
                    window.makeKeyAndVisible()
                }
            }
        }

        func navigateToMain() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let window = getKeyWindow() {
                    window.rootViewController = UIHostingController(rootView: Main())
                    window.makeKeyAndVisible()
                }
            }
        }


    
}

#Preview {
    
    AlertFail(
        isActive: .constant(true),
        title: "Contoh",
        message: "Ini hanya contoh preview",
        difficultyView: "Custom"
    ) {
        print("Tombol ditekan!")
    }
}

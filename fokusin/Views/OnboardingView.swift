//
//  Onboarding.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 21/05/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding : Bool
    var body: some View {
        ZStack{
            Color("Bg-Yellow")
            Image("onboard-0")
                .scaledToFill()
                .ignoresSafeArea()
                .padding(.leading,25)
            
            
            
            VStack {
                Spacer()
                VStack(spacing:20) {
                    
                    Text("Pecahkan Telurnya, Temukan Kejutan Fauna di Dalamnya!")
                        .foregroundColor(Color("Text1"))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 320)
                    
                    
                    
                    
                    Button(action: {
                        shouldShowOnboarding = false
                    }) {
                        Text("LANJUTKAN")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .foregroundColor(Color("Text2"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom, 90)
            }
            
            
        }
        
        
    }
}

#Preview {
    StatefulPreviewWrapper(true) { binding in
        AnyView(OnboardingView(shouldShowOnboarding: binding))
    }
}

//
//  SpalashScreenView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 21/05/25.
//

import SwiftUI

struct SplashScreenView: View {
    @StateObject private var viewModel = SplashScreenViewModel()

    var body: some View {
        if viewModel.isActive {
            if viewModel.shouldShowOnboarding{
                OnboardingView(shouldShowOnboarding: $viewModel.shouldShowOnboarding)
            }else{
                ContentView()
            }
        } else {
            VStack {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                Text("Splash Screen")
            }
        }
    }
}


#Preview {
    SplashScreenView()
}

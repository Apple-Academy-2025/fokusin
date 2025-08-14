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
                Homepageview()
            }
        } else {
            VStack {
                Image("applogo")
                    .resizable()
                    .frame(width: 300, height: 300)
                
            }
        }
    }
}


#Preview {
    SplashScreenView()
        .modelContainer(for: PomodoroSession.self, inMemory: true)
}


//
//  SplashScreenViewModels.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 21/05/25.
//

import Foundation

class SplashScreenViewModel: ObservableObject {
    @Published var isActive: Bool = false
    @Published var shouldShowOnboarding: Bool = false

    init(duration: TimeInterval = 2.0) {
        // Jalankan timer sederhana selama 2 detik
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.checkFirstLaunch() // cek dulu lif
            self.isActive = true
        }
    }
    
    func checkFirstLaunch() {
//        haslaunched defaultnya adalah false. nilai dari string "hashLaunchedBefore" bisa diganti kata lain, itu hanya untuk memberi nama key aja.
        
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

           if !hasLaunchedBefore {
               self.shouldShowOnboarding = true
               UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
           } else {
               self.shouldShowOnboarding = false
           }
    }
}


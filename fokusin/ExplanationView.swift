//
//  ExplanationView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 16/03/25.
//

import SwiftUI

struct ExplanationView: View {
    let difficulty: String
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 200, height: 200)
                    
                    Text(difficulty.uppercased())
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                
                Spacer()
                
                Text(explanationForDifficulty())
                    .font(.title2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                NavigationLink(destination: CountdownView(difficulty: difficulty)) {
                    Text("Start Timer")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        
    }
    
    private func explanationForDifficulty() -> String {
        switch difficulty {
        case "ez": return "Mode easy: 15 menit fokus dengan 5 menit istirahat."
        case "med": return "Mode medium: 25 menit fokus dengan 5 menit istirahat."
        case "hard": return "Mode hard: 45 menit fokus dengan 15 menit istirahat."
        case "custom": return "Mode custom: Atur timer sesuai keinginan."
        default: return "Mode tidak dikenal."
        }
    }
}



#Preview {
    ExplanationView(difficulty: "ez")
}

//
//  FokusModeView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 25/03/25.
//

import SwiftUI

struct FocusModeView: View {
    var focusTime: Int
    var restTime: Int
    var sessionCount: Int
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("Focus")
                    .font(.headline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                
                Text(formatTime(focusTime))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            
            VStack {
                Text("Break")
                    .font(.headline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                
                Text(formatTime(restTime))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            
            VStack {
                Text("Session")
                    .font(.headline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                
                Text("\(sessionCount)x")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .cornerRadius(10)
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secondsRemaining = seconds % 60
        return String(format: "%02d:%02d", minutes, secondsRemaining)
    }
}

struct FocusModeView_Previews: PreviewProvider {
    static var previews: some View {
        FocusModeView(focusTime: 900, restTime: 180, sessionCount: 1)
    }
}


//
//  Onboarding.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 21/05/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding : Bool
    @Environment(\.horizontalSizeClass) private var hClass

    var body: some View {
        GeometryReader { geo in
            let isPadLike = (hClass == .regular && geo.size.width >= 700)
            let contentWidth: CGFloat = min(geo.size.width * (isPadLike ? 0.55 : 0.90),isPadLike ? 520 : 360)
            let contentHeigh: CGFloat = min(geo.size.width * (isPadLike ? 20 : 10),isPadLike ? 250 : 250)
            let titleSize: CGFloat   = isPadLike ? 28 : 20
            let buttonFont: CGFloat  = isPadLike ? 20 : 16
            let buttonHeight: CGFloat = isPadLike ? 56 : 48
            let bottomPad: CGFloat   = max(geo.safeAreaInsets.bottom, 24)

            ZStack {
                // background image
                Color("Bg-Yellow").ignoresSafeArea()
                Image("onboard-0")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    

                // content
                VStack {
                    Spacer()
                    VStack(spacing: isPadLike ? 20 : 16) {
                        Text("Pecahkan Telurnya, Temukan Kejutan Fauna di Dalamnya!")
                            .font(.system(size: titleSize, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: contentWidth)
                            .foregroundColor(.primary)
                            .padding()
                        Button {
                            shouldShowOnboarding = false
                        } label: {
                            Text("LANJUTKAN")
                                .font(.system(size: buttonFont, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .frame(height: buttonHeight)
                                .background(Color.bgYellow)
                                .foregroundColor(Color("Text2"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.yellow, lineWidth: 2)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .frame(maxWidth: contentWidth)
                        .padding()
                    }
                   
                    .padding(.vertical, isPadLike ? 22 : 16)
                    .frame(maxWidth: contentWidth + 24, maxHeight: contentHeigh-20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.25), radius: 18, y: 6)
                    .padding(.horizontal, 24)
                    .padding(.bottom, bottomPad)
                }
            }
            .ignoresSafeArea()
        }
    }
}

// Preview helper
private struct OnboardingPreviewWrapper: View {
    @State private var show = true
    var body: some View { OnboardingView(shouldShowOnboarding: $show) }
}

#Preview { OnboardingPreviewWrapper() }



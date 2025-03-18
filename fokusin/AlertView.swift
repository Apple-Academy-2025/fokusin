//
//  AlertView.swift
//  fokusin1
//
//  Created by Muhamad Alif Anwar on 18/03/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func alertView<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: @escaping() -> (),
        @ViewBuilder content: @escaping() -> Content
    ) -> some View {
        self
            .modifier(AlertViewHelper(isPresented: isPresented, onDismiss: onDismiss, viewContent: content))
    }
}

fileprivate struct AlertViewHelper<ViewContent: View>: ViewModifier {
    @Binding var isPresented : Bool
    var onDismiss: () -> ()
    @ViewBuilder var viewContent: ViewContent
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented, onDismiss: onDismiss){
                viewContent
                    .presentationBackground(.clear)
            }
    }
}

#Preview {
    AlertPreviewWrapper()
}

struct AlertPreviewWrapper: View {
    @State private var showAlert = true
    @State private var remainingSessions = 3

    var body: some View {
        VStack {
            Text("Contoh Alert View")
                .alertView(isPresented: $showAlert, onDismiss: { remainingSessions -= 1 }) {
                    VStack {
                        Text("Focus Time Selesai!")
                            .font(.headline)
                            .padding()
                        Text("Sesi tersisa: \(remainingSessions)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 250, height: 150)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                }
        }
    }
}

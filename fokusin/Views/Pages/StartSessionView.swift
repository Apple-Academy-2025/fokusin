//
//  StartSessionView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 08/08/25.
//

import SwiftUI
import SwiftData

struct StartSessionView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Input
    let title: String
    let focusMinutes: Int
    let breakMinutes: Int
    let cycles: Int

    // State timer
    @State private var currentCycle = 1
    @State private var isFocus = true
    @State private var isRunning = false
    @State private var remaining = 0
    @State private var total = 0
    @State private var isFinishedAll = false

    // Akumulator durasi real (detik)
    @State private var focusAccum = 0
    @State private var breakAccum = 0

    // Alerts
    @State private var showEndAlert = false
    @State private var showFinishAlert = false

    // Timer 1 detik
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // Progress 0...1
    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return 1 - CGFloat(remaining) / CGFloat(total)
    }

    private var phaseTitle: String { isFinishedAll ? "Selesai" : (isFocus ? "Fokus" : "Istirahat") }
    private var primaryButtonTitle: String {
        if isFinishedAll { return "Selesai" }
        if isRunning { return "Akhiri" }
        return remaining == 0 ? "Mulai" : "Lanjut"
    }

    private var focusLabel: String { "\(focusMinutes) mnt" }
    private var breakLabel: String { "\(breakMinutes) mnt" }
    private var nextPhaseText: String {
        if isFinishedAll { return "—" }
        if isFocus { return currentCycle == cycles ? "Selesai" : "Istirahat \(breakMinutes) mnt" }
        return currentCycle < cycles ? "Fokus \(focusMinutes) mnt" : "Selesai"
    }

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            let ringSize = min(isLandscape ? geo.size.height * 0.65 : 260,
                               isLandscape ? geo.size.width * 0.40  : 320)

            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 80)
                    .fill(Color.bgCircle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(-1)
                    .offset(y: isLandscape ? 10 : 120)

                Group {
                    if isLandscape {
                        // LANDSCAPE: dua kolom, vertikalnya center
                        HStack(spacing: 24) {
                            VStack(spacing: 14) {
                                timerRing(size: ringSize)
                                Text("Siklus \(currentCycle) dari \(cycles)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("Text2").opacity(0.7))
                                    .offset(y:20)
                                    
                            }
                            .frame(maxWidth: .infinity)
                            

                            VStack(alignment: .leading, spacing: 16) {
                                Text(phaseTitle)
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(Color("Text2"))

                                Text("Selanjutnya: \(nextPhaseText)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("Text2").opacity(0.85))

                                HStack(spacing: 10) {
                                    InfoChip(icon: "bolt.fill",  text: focusLabel)
                                    InfoChip(icon: "pause.fill", text: breakLabel)
                                    InfoChip(icon: "repeat",     text: "\(currentCycle)/\(cycles)")
                                }

                                controls(isLandscape: true)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // ⬅️ center vertical
                    } else {
                        // PORTRAIT
                        VStack(spacing: 22) {
                            Text(phaseTitle)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(Color("Text2"))
                                .padding(.top, 20)

                            // Hapus spacer tinggi, cukup padding agar tidak menjorok
                            timerRing(size: ringSize)
                                .padding(.top, 24)

                            Text("Selanjutnya: \(nextPhaseText)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("Text2").opacity(0.8))
                                .padding(.top, 24)

                            HStack(spacing: 10) {
                                InfoChip(icon: "bolt.fill",  text: focusLabel)
                                InfoChip(icon: "pause.fill", text: breakLabel)
                                InfoChip(icon: "repeat",     text: "\(currentCycle)/\(cycles)")
                            }
                            .padding(.top, 4)

                            Spacer()

                            controls(isLandscape: false)
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
            .background(Color.bgYellow.ignoresSafeArea())
        }
        .tint(Color("Text2"))
        .onAppear { setupFirstPhase() }
        .onReceive(timer) { _ in
            guard isRunning, !isFinishedAll else { return }
            tick()
        }
        .alert("Akhiri sesi?", isPresented: $showEndAlert) {
            Button("Batal", role: .cancel) { }
            Button("Ya, akhiri", role: .destructive) { endAndGoHome(savePartial: false) }
        } message: {
            Text("Progres sesi ini akan dihentikan dan kamu akan kembali ke halaman utama.")
        }
        .alert("Selamat!", isPresented: $showFinishAlert) {
            Button("Tetap di sini") { }
            Button("Ke Home") { goHome() }
        } message: {
            Text("Kamu sudah menyelesaikan \(cycles) siklus. Mantap! 🎉")
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(phaseTitle). Sisa waktu \(timeString(remaining))")
    }

    // MARK: - Subviews

    private func timerRing(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Color.whiteCircle.opacity(2), lineWidth: 45)
                .frame(width: size, height: size)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.bgYellow, style: StrokeStyle(lineWidth: 45, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
                .animation(.easeInOut(duration: 0.2), value: progress)
            Text(timeString(isFinishedAll ? 0 :
                            (remaining == 0 ? (isFocus ? focusMinutes * 60 : breakMinutes * 60) : remaining)))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundColor(Color("Text2"))
        }
    }

    // ⬇️ Ganti computed property menjadi FUNGSI + @ViewBuilder
    @ViewBuilder
    private func controls(isLandscape: Bool) -> some View {
        VStack(spacing: 8) {
            Button { primaryAction() } label: {
                Text(primaryButtonTitle)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(isRunning ? Color.black : Color.white)
                            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
                    )
                    .foregroundColor(isRunning ? .white : Color("Text2"))
            }
            .disabled(isFinishedAll)

            Button("Reset") { resetAll() }
                .font(.subheadline)
                .foregroundColor(Color("Text2").opacity(0.8))
                .padding(.bottom, 8)
        }
        .offset(y: isLandscape ? 0 : -40)
    }

    // MARK: - Logic

    private func setupFirstPhase() {
        isFocus = true
        currentCycle = 1
        remaining = focusMinutes * 60
        total = remaining
        isRunning = false
        isFinishedAll = false
        focusAccum = 0
        breakAccum = 0
    }

    private func primaryAction() {
        if isFinishedAll { return }
        if isRunning { showEndAlert = true; return }
        if remaining == 0 { startPhase() }
        isRunning = true
    }

    private func startPhase() {
        remaining = (isFocus ? focusMinutes : breakMinutes) * 60
        total = remaining
    }

    private func tick() {
        guard remaining > 0 else { nextPhase(); return }
        remaining -= 1
        if isFocus { focusAccum += 1 } else { breakAccum += 1 }
    }

    private func nextPhase() {
        if isFocus {
            if currentCycle == cycles {
                isRunning = false
                isFinishedAll = true
                remaining = 0
                saveCompletion()
                showFinishAlert = true
                return
            }
            isFocus = false
            startPhase()
        } else {
            currentCycle += 1
            isFocus = true
            startPhase()
        }
    }

    private func saveCompletion() {
        let store = PomodoroStore(ctx: modelContext)
        try? store.addSession(
            modeTitle: title,
            cycles: currentCycle,
            focusSeconds: focusAccum,
            breakSeconds: breakAccum,
            completed: true
        )
    }

    private func endAndGoHome(savePartial: Bool) {
        isRunning = false
        isFinishedAll = true
        remaining = 0
        if savePartial {
            let store = PomodoroStore(ctx: modelContext)
            try? store.addSession(
                modeTitle: title,
                cycles: currentCycle,
                focusSeconds: focusAccum,
                breakSeconds: breakAccum,
                completed: false
            )
        }
        goHome()
    }

    private func goHome() {
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { dismiss() }
    }

    private func resetAll() { setupFirstPhase() }

    private func timeString(_ s: Int) -> String {
        String(format: "%02d:%02d", s/60, s%60)
    }
}

#Preview {
    StartSessionView(title: "Mode Pendek", focusMinutes: 1, breakMinutes: 1, cycles: 2)
}





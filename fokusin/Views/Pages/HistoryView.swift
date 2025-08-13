//
//  HistoryView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 10/08/25.
//

//
//  HistoryView.swift
//  fokusin
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var ctx
    // Observe settings agar auto-refresh saat skin diset dari tempat lain
    @Query private var settings: [AppSettings]

    @State private var totalAllTimeMinutes = 0
    @State private var todayMinutes = 0
    @State private var currentAssetName = "CharNest1"

    // Alert kalau pilih skin terkunci
    @State private var showLockedAlert = false
    @State private var lockedName = ""

    // Config progres telur (trophy)
    private let maxEggs: Int = 15
    private let baseHours: Int = 6

    // MARK: - Perhitungan progres kumulatif telur (6h, 7h, 8h, ...)
    private var progressInfo: (unlocked: Int, stageProgress: Double, currentReqHours: Int, hoursLeft: Int) {
        var unlocked = 0
        var remaining = totalAllTimeMinutes
        var reqHours = baseHours
        while unlocked < maxEggs {
            let need = reqHours * 60
            if remaining >= need {
                unlocked += 1
                remaining -= need
                reqHours += 1
            } else { break }
        }
        let currentNeed = reqHours * 60
        let stageProgress = min(1.0, currentNeed == 0 ? 1.0 : Double(remaining) / Double(currentNeed))
        let minsLeft = max(0, currentNeed - remaining)
        let hoursLeft = Int(ceil(Double(minsLeft) / 60.0))
        return (unlocked, stageProgress, reqHours, hoursLeft)
    }
    private var unlockedCount: Int { progressInfo.unlocked }
    private var stageProgress: Double { progressInfo.stageProgress }
    private var hoursLeft: Int { progressInfo.hoursLeft }

    private var infoLine: String {
        if unlockedCount >= maxEggs { return "Semua telur sudah ter-unlock 🎉" }
        if hoursLeft == 0 { return "Sedikit lagi! Menit terakhir menuju telur berikutnya 🥚" }
        return "Capai \(hoursLeft) jam lagi untuk evolusi telurmu!"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Karakter aktif (tap untuk ganti juga bisa lewat grid di bawah)
                Image(currentAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 125)
                    .accessibilityLabel("Karakter aktif \(currentAssetName)")

                // Kartu counter telur (rata kiri)
                EggCounterCard(unlockedCount: unlockedCount)
                    .frame(maxWidth: 160, alignment: .leading)

                // Progress bar + info
                ProgressEggBar(progress: stageProgress)
                    .frame(width: 260, height: 12)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(infoLine)
                    .font(.body.weight(.semibold))
                    .foregroundColor(Color("Text2"))

                // Ringkasan waktu
                HStack(spacing: 10) {
                    SummaryCard(title: "Total Waktu",
                                line1: "\(totalAllTimeMinutes / 60) Jam",
                                line2: "\(totalAllTimeMinutes % 60) Menit")
                    SummaryCard(title: "Total Hari ini",
                                line1: "\(todayMinutes / 60) Jam",
                                line2: "\(todayMinutes % 60) Menit")
                }

                // Grid progres telur (trophy)
//                EggGrid(unlocked: unlockedCount, maxEggs: maxEggs)

                // === Grid PILIH KARAKTER ===
                CharacterGrid(
                    totalMinutes: totalAllTimeMinutes,
                    selectedID: currentSelectedIDOrDefault,
                    onSelect: { skin in
                        selectSkin(skin)
                    },
                    onLockedTap: { skin in
                        lockedName = skin.displayName
                        showLockedAlert = true
                    }
                )
                .padding(.top, 8)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .tint(Color("Text2"))
        .onAppear { loadDataAndSkin() }
        .onChange(of: settings.first?.selectedSkinID) { _ in
            // auto refresh jika setting berubah di tempat lain
            try? updateSkinAsset()
        }
        .alert("Belum terbuka", isPresented: $showLockedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(lockedName) masih terkunci. Naikkan waktu fokusmu dulu ya!")
        }
    }

    // MARK: - Data & Skin

    private var currentSelectedIDOrDefault: String {
        // fallback aman bila belum ada AppSettings
        settings.first?.selectedSkinID ?? "charnest1"
    }

    @MainActor
    private func loadDataAndSkin() {
        let store = PomodoroStore(ctx: ctx)
        totalAllTimeMinutes = (try? store.totalFocusMinutesAllTime()) ?? 0
        todayMinutes        = (try? store.totalFocusMinutes(on: Date())) ?? 0
        try? updateSkinAsset()
    }

    @MainActor
    private func updateSkinAsset() throws {
        let skin = try SkinManager(ctx: ctx).currentSkin(totalMinutes: totalAllTimeMinutes)
        currentAssetName = skin.assetName
    }

    @MainActor
    private func selectSkin(_ skin: CharacterSkin) {
        do {
            let ok = try SkinManager(ctx: ctx).select(skinID: skin.id, totalMinutes: totalAllTimeMinutes)
            if ok {
                currentAssetName = skin.assetName
            } else {
                lockedName = skin.displayName
                showLockedAlert = true
            }
        } catch {
            print("Select skin error: \(error)")
        }
    }
}

// MARK: - Subviews yang sudah ada

private struct EggCounterCard: View {
    let unlockedCount: Int
    var body: some View {
        Group {
            HStack(spacing: 10) {
                Image("unlockegg").resizable().scaledToFit().frame(width: 22, height: 22)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(unlockedCount) Telur").font(.headline).foregroundColor(Color("Text2"))
                    Text("terkumpul").font(.subheadline).foregroundColor(Color("Text2").opacity(0.7))
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
        }
    }
}

private struct ProgressEggBar: View {
    var progress: Double
    var widthRatio: CGFloat = 1
    var barHeight: CGFloat = 20
    var body: some View {
        GeometryReader { geo in
            let totalW = geo.size.width
            let barW = max(0, min(totalW, totalW * widthRatio))
            let h = barHeight
            let p = max(0, min(1, progress))
            let fillW = barW * p
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.orange.opacity(0.22))
                    .frame(width: barW, height: h)
                    .overlay(alignment: .trailing) {
                        Image("unlockegg")
                            .resizable().scaledToFit()
                            .frame(height: h * 1.6)
                            .padding(.trailing, 2)
                    }
                Capsule()
                    .fill(Color.orange.opacity(0.65))
                    .frame(width: fillW, height: h)
                Circle()
                    .fill(Color.brown)
                    .frame(width: h, height: h)
                    .offset(x: max(0, fillW - h))
                    .opacity(p > 0 ? 1 : 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: barHeight)
    }
}

private struct SummaryCard: View {
    let title: String
    let line1: String
    let line2: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Image("unlockegg").resizable().scaledToFit().frame(width: 20, height: 20)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline).foregroundColor(Color("Text2"))
                    HStack {
                        Text(line1).font(.subheadline.weight(.semibold)).foregroundColor(Color("Text2"))
                        Text(line2).font(.subheadline).foregroundColor(Color("Text2").opacity(0.7))
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.orange.opacity(0.12), lineWidth: 1))
                .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
        )
    }
}

private struct EggGrid: View {
    let unlocked: Int
    let maxEggs: Int
    private let eggImageName = "unlockegg"
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 64, maximum: 64), spacing: 12)]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progres Telurmu")
                .font(.headline)
                .foregroundColor(Color("Text2"))
                .padding(.horizontal, 12)
                .padding(.top, 12)
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<maxEggs, id: \.self) { i in
                    let isUnlocked = i < unlocked
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        Image(eggImageName)
                            .resizable().scaledToFit()
                            .frame(width: 36, height: 36)
                            .saturation(isUnlocked ? 1 : 0)
                            .opacity(isUnlocked ? 1 : 0.35)
                            .accessibilityLabel(isUnlocked ? "Telur \(i+1) terbuka" : "Telur \(i+1) terkunci")
                    }
                    .frame(width: 64, height: 64)
                }
            }
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.orange.opacity(0.14))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.orange.opacity(0.12), lineWidth: 1))
                .shadow(color: .black.opacity(0.08), radius: 10, y: 6)
        )
    }
}

//
// === Grid PILIH KARAKTER ===
//
private struct CharacterGrid: View {
    let totalMinutes: Int
    let selectedID: String
    let onSelect: (CharacterSkin) -> Void
    let onLockedTap: (CharacterSkin) -> Void

    private let columns = [GridItem(.adaptive(minimum: 88), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pilih Karakter")
                .font(.headline)
                .foregroundColor(Color("Text2"))
                .padding(.horizontal, 12)
                .padding(.top, 4)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(CharacterSkins.all) { skin in
                    let unlocked = totalMinutes >= skin.requiredMinutes
                    let isSelected = selectedID == skin.id

                    Button {
                        if unlocked { onSelect(skin) } else { onLockedTap(skin) }
                    } label: {
                        VStack(spacing: 8) {
                            ZStack {
                                Image(skin.assetName)
                                    .resizable().scaledToFit()
                                    .frame(height: 64)
                                    .saturation(unlocked ? 1 : 0)
                                    .opacity(unlocked ? 1 : 0.35)
                                if !unlocked {
                                    Image(systemName: "lock.fill")
                                        .font(.caption.bold())
                                        .padding(6)
                                        .background(.thinMaterial, in: Circle())
                                        .offset(x: 24, y: 22)
                                }
                            }
                            Text(skin.displayName)
                                .font(.caption)
                                .foregroundColor(Color("Text2"))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                                )
                                .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.orange.opacity(0.10))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.orange.opacity(0.12), lineWidth: 1))
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }
}

#Preview {
    ({
        // In-memory SwiftData
        let schema = Schema([PomodoroSession.self, AppSettings.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: config)
        let ctx = ModelContext(container)

        // Seed: total fokus ≈ 7 jam → CharNest2 harusnya kebuka
        ctx.insert(PomodoroSession(modeTitle: "Seed-1", cycles: 4, focusSeconds: 3*60*60, breakSeconds: 10*60, completed: true))
        ctx.insert(PomodoroSession(modeTitle: "Seed-2", cycles: 3, focusSeconds: 4*60*60, breakSeconds: 15*60, completed: true))
        ctx.insert(AppSettings()) // default selectedSkinID = "charnest1"

        return NavigationStack { HistoryView() }
            .modelContainer(container)
            .background(Color(.systemGroupedBackground))
    })()
}





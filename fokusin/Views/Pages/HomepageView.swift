//
//  ContentView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 21/05/25.
//
import SwiftUI
import SwiftData

struct Homepageview: View {
    @Environment(\.modelContext) private var ctx
    @Environment(\.horizontalSizeClass) private var hClass

    // amati AppSettings supaya auto-refresh kalau skin dipilih dari History
    @Query private var settings: [AppSettings]

    @State private var totalAllTimeMinutes = 0
    @State private var currentAssetName = "CharNest1"   // fallback aman

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let isPadLike = (hClass == .regular && geo.size.width >= 700)

                let heroHeight: CGFloat = isPadLike ? min(geo.size.height * 0.42, 520) : 360
                let cardHeight: CGFloat = isPadLike ? 300 : 220
                let charWidth:  CGFloat = isPadLike ? min(geo.size.width * 0.35, 420) : 260
                let titleSize:  CGFloat = isPadLike ? 44 : 28
                let iconSize:   CGFloat = isPadLike ? 32 : 24

                ScrollView {
                    VStack(spacing: 20) {

                        // ===== Header / Hero =====
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Color.orange)
                                .frame(height: heroHeight)
                                .ignoresSafeArea(edges: .top)

                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Fokusin")
                                        .font(.system(size: titleSize, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.top, isPadLike ? 24 : 40)
                                        .padding(.leading, 20)
                                    Spacer()

                                    NavigationLink { HistoryView() } label: {
                                        CircularIcon(
                                            imageName: "History",
                                            size: iconSize,
                                            ringColor: .white,
                                            ringWidth: 2
                                        )
                                    }
                                    .padding(.top, isPadLike ? 28 : 45)
                                    .padding(.trailing, 30)
                                    .buttonStyle(.plain)
                                }

                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.chiken)
                                        .frame(height: cardHeight)
                                        .padding(.horizontal, 20)

                                    // --- karakter aktif mengikuti History ---
                                    Image(currentAssetName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: charWidth)
                                        .padding(.top, isPadLike ? 24 : 45)
                                }
                            }
                        }

                        // ===== Tombol Preset =====
                        VStack(spacing: 20) {
                            ForEach(PomodoroData.presets, id: \.id) { preset in
                                NavigationLink(destination: DetailViewPage(modeTitle: preset.title)) {
                                    ButtonHomePage(title: preset.title)
                                }
                                .buttonStyle(.plain)
                            }

                            NavigationLink(destination: DetailViewPage(modeTitle: "Mode Kustom")) {
                                ButtonHomePage(title: "Mode Kustom")
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: 900)
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color.bgYellow.ignoresSafeArea())
        }
        .tint(Color.text2)
        .onAppear { refreshSkin() }
        .onChange(of: settings.first?.selectedSkinID) { _ in
            // kalau user ganti skin di History, header ini ikut ganti
            refreshSkin()
        }
    }

    // MARK: - Data & Skin
    @MainActor
    private func refreshSkin() {
        // total menit fokus (all time) dari SwiftData
        let store = PomodoroStore(ctx: ctx)
        totalAllTimeMinutes = (try? store.totalFocusMinutesAllTime()) ?? 0

        // tentukan skin aktif berdasarkan AppSettings + aturan unlock
        if let skin = try? SkinManager(ctx: ctx).currentSkin(totalMinutes: totalAllTimeMinutes) {
            currentAssetName = skin.assetName
        } else {
            currentAssetName = "CharNest1" // fallback
        }
    }
}

struct CircularIcon: View {
    var imageName: String
    var size: CGFloat = 24
    var ringColor: Color = .white
    var ringWidth: CGFloat = 2

    var body: some View {
        ZStack {
            Circle()
                .stroke(ringColor, lineWidth: ringWidth)
                .frame(width: size + 16, height: size + 16)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.06), radius: 1, x: 0, y: 1)
        }
        .padding(4)
        .contentShape(Circle())
    }
}

#Preview {
    // preview dengan container in-memory supaya @Query tidak error
    let schema = Schema([PomodoroSession.self, AppSettings.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: config)

    // seed contoh: total fokus 7 jam → CharNest2 harus bisa dipilih
    let ctx = ModelContext(container)
    ctx.insert(PomodoroSession(modeTitle: "Seed-1", cycles: 3, focusSeconds: 3*60*60, breakSeconds: 0, completed: true))
    ctx.insert(PomodoroSession(modeTitle: "Seed-2", cycles: 2, focusSeconds: 4*60*60, breakSeconds: 0, completed: true))
    ctx.insert(AppSettings()) // default charnest1

    return Homepageview().modelContainer(container)
}

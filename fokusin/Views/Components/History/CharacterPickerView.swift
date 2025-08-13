//
//  CharacterPickerView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 11/08/25.
//



import SwiftUI
import SwiftData

struct CharacterPickerView: View {
    @Environment(\.modelContext) private var ctx
    let totalMinutes: Int
    var onSelected: (() -> Void)? = nil

    @State private var selectedID: String = "charnest1"
    @State private var showLockedAlert = false
    @State private var lockedName = ""

    private let grid = [GridItem(.adaptive(minimum: 96), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pilih Karakter")
                .font(.title2.bold())

            LazyVGrid(columns: grid, spacing: 12) {
                ForEach(CharacterSkins.all) { skin in
                    skinCell(skin)
                }
            }
        }
        .padding(16)
        .onAppear {
            // sinkronkan dengan skin yang tersimpan
            if let cur = try? SkinManager(ctx: ctx).currentSkin(totalMinutes: totalMinutes) {
                selectedID = cur.id
            }
        }
        .alert("Belum terbuka", isPresented: $showLockedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("\(lockedName) masih terkunci. Naikkan waktu fokusmu dulu ya!")
        }
    }

    private func skinCell(_ skin: CharacterSkin) -> some View {
        let unlocked = totalMinutes >= skin.requiredMinutes
        let isSelected = selectedID == skin.id

        return Button {
            Task { await select(skin) }
        } label: {
            VStack(spacing: 8) {
                Image(skin.assetName)
                    .resizable().scaledToFit()
                    .frame(height: 72)
                    .saturation(unlocked ? 1 : 0)
                    .opacity(unlocked ? 1 : 0.35)
                    .overlay(alignment: .bottomTrailing) {
                        if !unlocked {
                            Image(systemName: "lock.fill")
                                .font(.caption.bold())
                                .padding(6)
                                .background(.thinMaterial, in: Circle())
                        }
                    }

                Text(skin.displayName)
                    .font(.footnote)
                    .foregroundColor(.primary)

                if !unlocked {
                    Text("Butuh \(skin.requiredMinutes/60) jam")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
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

    @MainActor
    private func select(_ skin: CharacterSkin) async {
        do {
            let ok = try SkinManager(ctx: ctx).select(skinID: skin.id, totalMinutes: totalMinutes)
            if ok {
                selectedID = skin.id
                onSelected?()
            } else {
                lockedName = skin.displayName
                showLockedAlert = true
            }
        } catch {
            print("Select skin error: \(error)")
        }
    }
}

#Preview {
    ({
        let schema = Schema([PomodoroSession.self, AppSettings.self])
        let cfg    = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: cfg)

        let ctx = ModelContext(container)
        ctx.insert(PomodoroSession(modeTitle: "Seed",
                                   cycles: 1,
                                   focusSeconds: 6*60*60,
                                   breakSeconds: 0,
                                   completed: true))

        return CharacterPickerView(totalMinutes: 6*60)
            .modelContainer(container)
            .background(Color(.systemGroupedBackground))
    })()
}



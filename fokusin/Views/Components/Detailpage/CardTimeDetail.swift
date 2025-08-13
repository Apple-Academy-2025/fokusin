//
//  CardTimeDetail.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 12/07/25.
//

import SwiftUI

struct CardTimeDetail: View {
    // bind ke menit fokus, menit jeda, dan jumlah siklus
    @Binding var focusMinutes: Int
    @Binding var breakMinutes: Int
    @Binding var cycles: Int

    /// true = mode Kustom → tampilkan wheel picker
    var editable: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            WheelColumn(
                title: "Fokus",
                selection: $focusMinutes,
                range: 1...180,
                formatter: { String(format: "%02d:00", $0) },
                editable: editable
            )

            WheelColumn(
                title: "Jeda",
                selection: $breakMinutes,
                range: 1...60,
                formatter: { String(format: "%02d:00", $0) },
                editable: editable
            )

            WheelColumn(
                title: "Siklus",
                selection: $cycles,
                range: 1...10,
                formatter: { "\($0)x" },
                editable: editable
            )
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Subview
private struct WheelColumn: View {
    let title: String
    @Binding var selection: Int
    let range: ClosedRange<Int>
    let formatter: (Int) -> String
    let editable: Bool

    // tinggi card: lebih tinggi bila editable (untuk wheel)
    private var cardHeight: CGFloat { editable ? 140 : 70 }

    var body: some View {
        VStack(spacing: 8) {
            // header chip
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 120, height: 40)
                .background(RoundedRectangle(cornerRadius: 100).fill(Color.detailTimes))

            ZStack {
                // white card
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.stroke1, lineWidth: 2.9)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                    .frame(width: 120, height: cardHeight)

                if editable {
                    // WHEEL PICKER
                    Picker("", selection: $selection) {
                        ForEach(Array(range), id: \.self) { value in
                            Text(formatter(value))
                                .font(.system(size: 18, weight: .semibold))
                                .tag(value)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.wheel)
                    .frame(width: 100, height: cardHeight - 12)
                    .clipped()
                } else {
                    // TEXT STATIS (preset)
                    Text(formatter(selection))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("Text2"))
                }
            }
        }
        .frame(width: 120)
    }
}

#Preview {
    VStack(spacing: 24) {
        // PRESET (read-only)
        CardTimeDetail(
            focusMinutes: .constant(15),
            breakMinutes: .constant(3),
            cycles: .constant(2),
            editable: false
        )

        // KUSTOM (wheel)
        StatefulPreview()
    }
    .padding()
}

private struct StatefulPreview: View {
    @State private var f = 25
    @State private var b = 5
    @State private var c = 4

    var body: some View {
        CardTimeDetail(
            focusMinutes: $f,
            breakMinutes: $b,
            cycles: $c,
            editable: true
        )
    }
}


import SwiftUI

struct CustomTimePicker: View {
    let title: String
    let icon: String

    @Binding var totalSeconds: Int
    
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0

    var body: some View {
        VStack(alignment: .leading,spacing: 2) {
            HStack(alignment: .center, spacing: 12) { // 🔥 Pastikan sejajar tengah
                Image(systemName: "\(icon)")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.tombol2)
                    .frame(width: 20, height: 20) // 🔹 Sesuaikan ukuran ikon
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .baselineOffset(-1) // 🔹 Atur agar teks sejajar dengan ikon
            }
            
            .padding(.bottom,12)

            
            HStack(alignment: .center, spacing: 18) { // 🔥 Spacing antar elemen
                // 🔹 Picker Menit
                VStack {
                    Picker("Menit", selection: $minutes) {
                        ForEach(0..<60, id: \.self) { min in
                            Text(String(format: "%02d", min))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 120, height: 80)
                    .background(Color.brown.opacity(0.9)) // 🔥 Warna background
                    .cornerRadius(12) // 🔥 Rounded edges
                }
                
                // 🔹 Pemisah ":"
                Text(":")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .foregroundColor(.brown)
                
                // 🔹 Picker Detik
                VStack {
                    Picker("Detik", selection: $seconds) {
                        ForEach(0..<60, id: \.self) { sec in
                            Text(String(format: "%02d", sec))
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 120, height: 80)

                    .background(Color.brown.opacity(0.9))
                    .cornerRadius(12)
                }
            }
        }
        .onChange(of: minutes) { updateTotalSeconds() }
        .onChange(of: seconds) { updateTotalSeconds() }
        .onAppear {
            minutes = totalSeconds / 60
            seconds = totalSeconds % 60
        }
    }
    
    private func updateTotalSeconds() {
        totalSeconds = (minutes * 60) + seconds
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var time: Int = 90  // 1 menit 30 detik
        
        var body: some View {
            CustomTimePicker(title: "Fokus", icon: "clock" , totalSeconds: $time)
                .padding()
                // Warna latar belakang
        }
    }
    
    return PreviewWrapper()
}

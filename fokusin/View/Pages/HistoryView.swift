import SwiftUI
import Lottie

struct HistoryView: View {
    @StateObject private var viewModel = DifficultyViewModel()
//    let difficulty: String
    
    @State private var isShaking = false
    @State private var progress: CGFloat = 0.75 // Progress bar percentage (0.0 - 1.0)
    
    var body: some View {
      
            ZStack(alignment: .top) {
                Color.primer.edgesIgnoringSafeArea(.all)
                VStack{
                    //                heading
                    VStack() {
                        VStack {
                            Ellipse()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 150, height: 20)
                                .offset(y: 140)
                            
                            // 🔥 Animasi Telur Goyang
                            Image(.telurUtuh)
                                .resizable()
                                .frame(width: 90, height: 110)
                                .padding(.bottom, 5)
                                .rotationEffect(.degrees(isShaking ? 5 : -5))
                                .onAppear {
                                    withAnimation(
                                        Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)
                                    ) {
                                        isShaking.toggle()
                                    }
                                }
                                .padding()
                        }
                        .padding(.top, 40)
                        HStack(spacing: 10) {
                            StatCard(icon: "TelurUtuh", count: 2, label: "Berhasil", status: true)
                            StatCard(icon: "CrackEgg", count: 2, label: "Gagal", status: false)
                        }
                        
                        
                        
                        .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.primer1)
                    .cornerRadius(40)
                    .edgesIgnoringSafeArea(.top)
                    
                    //                body
                    VStack(alignment: .center) {
//                        ZStack(alignment: .leading) {
//                            RoundedRectangle(cornerRadius: 10)
//                                .frame(width: 300, height: 15)
//                                .foregroundColor(Color.gray.opacity(0.3))
//    
//                            RoundedRectangle(cornerRadius: 10)
//                                .frame(width: 300 * progress, height: 15)
//                                .foregroundColor(.orange)
//                        }
//                        Text("Capai 5 jam lagi untuk evolusi telurMu!")
//                            .font(.headline)
//                            .foregroundColor(.black)
//                            .padding(.vertical, 5)
                        
                        NavigationLink(destination: DetailView()) {
                            Text("klik aku")
                        }
                        
                        
                        HStack(spacing: 10) {
                            TotalTimeCard(icon: "clock", count: 2, label: "Total waktu", status: true)
                            TotalTimeCard(icon: "target", count: 2, label: "Hari ini", status: false)
                        }
                        
                        
                        // Riwayat
                        VStack {
                            VStack {
                                CardSession(mode: "Mode Short", duration: "15:00 Menit", count: 1)
                                CardSession(mode: "Mode Reguler", duration: "15:00 Menit", count: 1)
                                CardSession(mode: "Mode long", duration: "15:00 Menit", count: 1)
                                CardSession(mode: "Mode Custom", duration: "15:00 Menit", count: 1)
                                
                                
                                // ⏰ Menampilkan daftar detail aktivitas
                                
                                
                            }
                            .overlay(alignment: .top) {
                                Text( "HISTORY")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.primer)
                                    .zIndex(10)
                                    .padding(.horizontal, 45)
                                    .padding(.vertical, 5)
                                    .background(.tombol2)
                                    .cornerRadius(10)
                                    .offset(y: -20)
                            }
                            .padding(.top,30)
                        }.padding(.bottom,20)
                        
                    }
                    .padding(.top,-80)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .padding(.horizontal)
                }
                
                
            }
        }
      
    }


// 🛠️ Preview
#Preview {
    HistoryView()
}

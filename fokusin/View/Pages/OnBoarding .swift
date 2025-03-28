import SwiftUI

struct OnBoarding: View {
    @State private var isActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primer1.edgesIgnoringSafeArea(.all)
                VStack {
                    
                    Spacer()
                    Image(.multiCrack)
                        .resizable()
                        .frame(width: 300, height: 280)
                        .padding(.bottom, 80)
                    
                    
                    Text("Stay Focus,")
                        .foregroundColor(.tombol2)
                        .bold()
                        .font(.title)
                    Text("Take Care of the Eggs,")
                        .foregroundColor(.tombol2)
                        .bold()
                        .font(.title)
                    Text("Dont Let it Break")
                        .foregroundColor(.tombol2)
                        .bold()
                        .font(.title)
                        .padding(.bottom, 50)
                    
                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        isActive = true
                    }) {
                        Text("CONTINUE")
                            .foregroundColor(.tombol2)
                            .frame(width: 200, height: 50)
                            .fontWeight(.bold)
                            .background(Color.tombol)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 3)
                    }
                    .navigationDestination(isPresented: $isActive) {
                        Main()
                    }


                    Spacer()
                }
            }
        }
    }
}

#Preview {
    OnBoarding()
}


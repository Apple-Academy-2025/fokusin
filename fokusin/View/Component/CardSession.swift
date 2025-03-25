import SwiftUI

struct CardSession: View {
    let mode: String
    let duration: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Egg Icon
            Image("TelurUtuh")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange)
                .padding()
                .background(Color.orange.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Mode and Duration
            VStack(alignment: .leading) {
                Text(mode)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(duration)
                    .font(.subheadline)
                    .foregroundColor(.brown)
            }
            Spacer()
            
            // Count Indicator
            Text("\(count) ×")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .background(Color.orange.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(width: .infinity, height: 70)
        .padding(5)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 3)
        
        
    }
}

// Preview
#Preview {
    CardSession(mode: "Mode Short", duration: "15:00 Menit", count: 1)
}

//
//  CongratsComp.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 21/03/25.
//

import SwiftUI
    

struct CustomAlert: View {
    
    
    @Binding var isActive : Bool
    
    @State var title: String
    @State var message: String
    @State var buttonTitle: String
    var action: () -> Void
    @State private var offset: CGFloat = 1000
//    let action : () -> ()
    
    var body: some View {
        
        ZStack{
        Color(.black)
            .opacity(0.5)
            .onTapGesture {
                close()
            }
            VStack{
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()
                
                Text(message)
                    .font(.body)
                
                Button{
    //                logic
                    action()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.tombol2)
                        
                        Text(buttonTitle)
                            .font(.system(size:16, weight: .bold))
                            .foregroundColor(.primer)
                            .padding()
                    }
                    .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topTrailing){
                VStack{
                    HStack{
                        Spacer()
                        Button{
                            close()
                        }label :{
                            Image(systemName:"xmark")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .tint(.black)
                        .padding()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x:0,y:offset)
            .onAppear{
                withAnimation(.spring()){
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
     
    func close () {
        withAnimation(.spring()){
            offset = 1000
            isActive = false
        }
    }
}



#Preview {
    CustomAlert( isActive: .constant(true), title: "ini cohntoh", message: "Ini hanya muncul saat priview doang", buttonTitle: "Keluar"){
        print("Tombol ditekan!") // Contoh aksi saat tombol ditekan
    }
}

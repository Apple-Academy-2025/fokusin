//
//  testPemahaman.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 22/05/25.
//

import Foundation

class cekViewModel : ObservableObject {
    @Published var isNyala : Bool = false
    @Published var isPernah : Bool = false
    
    init(duration : TimeInterval = 2.0){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isNyala = true
            self.isPernah = true
        }
    }
    
    func cekUdahBelum(){
        let cekAja = UserDefaults.standard.bool(forKey: "ambilJejak")
        
        
        if !cekAja {
            self.isPernah = true
            UserDefaults.standard.set(true, forKey: "ambilJejak")
           
        }else{
            self.isPernah = false
        }
    }
}

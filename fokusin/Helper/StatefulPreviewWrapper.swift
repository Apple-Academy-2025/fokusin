//
//  StatefulPreviewWrapper.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 10/07/25.
//

import Foundation
import SwiftUI

struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView
    
    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> AnyView) {
        _value = State(wrappedValue: initialValue)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}

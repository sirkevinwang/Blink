//
//  MenuToggleView.swift
//  Blink
//
//  Created by Kevin Wang on 1/5/21.
//

import SwiftUI

struct MenuToggleView: View {
    @State private var isTracking = false
    var body: some View {
        VStack {
            HStack {
                Text("Tracking Eye Blinks")
                Spacer()
                Toggle(isOn: $isTracking) {
                    
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct MenuToggleView_Previews: PreviewProvider {
    static var previews: some View {
        MenuToggleView()
            .frame(width: 200.0, height: 50.0, alignment: .center)
    }
}

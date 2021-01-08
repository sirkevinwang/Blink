//
//  AlertView.swift
//  Blink
//
//  Created by Kevin Wang on 1/8/21.
//

import SwiftUI

struct AlertView: View {
    var alertText: String
    var alertIcon: Image
    
    var body: some View {
        VStack {
            alertIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0, height: 80.0, alignment: .center)
                .padding(.bottom)
            
            Text(alertText)
                .font(.title)
                .fontWeight(.medium)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .visualEffect(material: .popover)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlertView(alertText: "Blink More", alertIcon: Image(systemName: "eyebrow"))
            .frame(width: 200.0, height: 200.0, alignment: .center)
            AlertView(alertText: "Tracking Paused", alertIcon: Image(systemName: "pause.circle.fill"))
                .frame(width: 200.0, height: 200.0, alignment: .center)
        }
        
    }
}

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
    var blinks: Int?
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
            
            if let blinkCnt = blinks {
                Text("\(blinkCnt) blinks past minute")
                    .font(.headline)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .frame(maxWidth: 220, maxHeight: 220)
        .cornerRadius(12.0)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlertView(alertText: "Try to Blink More", alertIcon: Image(systemName: "eyebrow"), blinks: 8)
            .frame(width: 220.0, height: 220.0, alignment: .center)
            AlertView(alertText: "Tracking Paused", alertIcon: Image(systemName: "pause.circle.fill"), blinks: nil)
                .frame(width: 220.0, height: 220.0, alignment: .center)
        }
        
    }
}

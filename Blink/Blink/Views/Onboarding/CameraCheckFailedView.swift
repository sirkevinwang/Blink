//
//  CameraCheckFailedView.swift
//  Blink
//
//  Created by Kevin Wang on 3/11/21.
//

import SwiftUI

struct CameraCheckFailedView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                HStack {
                    VStack (alignment: .leading){
                        Text("Camera Access Not Granted")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                        Text("You can open System Preferences and navigate to Security & Privacy > Camera to grant Blink permission to access your camera.")
                            .font(.title3)
                            .padding(.top, 10)
                            .padding(.bottom, 13)
                        
                        Button(action: {
                            NSApp.terminate(self)
                        }, label: {
                            Text("Quit Blink")
                                .font(.body)
                        })
                        
                    }
                    Spacer()
                    Image("WelcomeCameraIcon")
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .center)
                }
                .padding(.horizontal, 60)
               Spacer()
                
            }
            Text("Blink doesn't store or upload your camera data. We use on-device machine learning to detect eye blinks.")
                .font(.caption)
                .foregroundColor(Color(.systemGray))
                .padding(.bottom)
        }
    }
}

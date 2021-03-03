//
//  CameraCheckView.swift
//  Blink
//
//  Created by Kevin Wang on 3/3/21.
//

import SwiftUI

struct CameraCheckView: View {
    @Binding var currentOnboardState: OnboardingStates
    var body: some View {
        VStack {
            
            HStack {
                VStack (alignment: .leading){
                    Text("Camera Access")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("We use your camera to track eye blinks.")
                        .font(.title3)
                        .padding(.top, 10)
                        .padding(.bottom, 13)
                    
                    Button(action: {
                    }, label: {
                        Text("Allow Access")
                            .font(.body)
                    })
                    
                }
                Spacer()
                Image("CameraIcon")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
            }
            .padding(.horizontal, 60)

            
        }
    }
}


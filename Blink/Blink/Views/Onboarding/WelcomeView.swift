//
//  WelcomeView.swift
//  Blink
//
//  Created by Kevin Wang on 3/2/21.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currentOnboardState: OnboardingStates
    var body: some View {
        VStack {
            
            HStack {
                VStack (alignment: .leading){
                    Text("Welcome to Blink")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("A fun little app that reminds you to blink more frequently.")
                        .font(.title3)
                        .padding(.top, 10)
                        .padding(.bottom, 13)
                    
                    Button(action: {
                        currentOnboardState = .cameraCheck
                    }, label: {
                        Text("Get Started")
                            .font(.body)
                    })
                    
                }
                Spacer()
                Image("Logo")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
            }
            .padding(.horizontal, 60)
            
        }
    }
}

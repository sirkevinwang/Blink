//
//  WelcomeCompleteView.swift
//  Blink
//
//  Created by Kevin Wang on 3/3/21.
//

import SwiftUI
import Cocoa

struct WelcomeCompleteView: View {
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading){
                    Text("Where's Blink")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("You can always find Blink on your status bar.")
                        .font(.title3)
                        .padding(.top, 10)
                        .padding(.bottom, 13)
                    
                    Button(action: {
                        // closes onboarding window
                        NSApplication.shared.keyWindow?.close()
                    }, label: {
                        Text("Done")
                            .font(.body)
                    })
                    
                }
                Spacer()
                Image("WelcomeStatusBarIcon")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
            }
            .padding(.horizontal, 60)

            
        }
        .onAppear(perform: {
            // TODO: need to call setupUI in app delegate
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.welcomeViewDidFinishSetup()
        })
    }
}

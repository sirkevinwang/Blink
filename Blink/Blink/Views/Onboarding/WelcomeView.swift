//
//  WelcomeView.swift
//  Blink
//
//  Created by Kevin Wang on 3/2/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                VStack (alignment: .leading){
                    Text("Welcome to Blink")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("A fun little app that reminds you to blink more frequently.")
                        .font(.title3)
                        .padding(.top, 10)
                        .padding(.bottom, 13)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Get Started")
                            .font(.body)
                    })
                    
                }
                Spacer()
                Image("Logo")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                Spacer()
            }
            
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

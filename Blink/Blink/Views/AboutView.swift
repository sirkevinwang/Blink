//
//  AboutView.swift
//  Blink
//
//  Created by Kevin Wang on 1/7/21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .resizable()
                .frame(width: 100.0, height: 100.0)
            Text("Blink")
                .font(.title)
            Text("Copyright 2021 Yunxiao Wang")
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .visualEffect(material: .popover)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .frame(width: 250.0, height: 350.0, alignment: .center)
    }
}

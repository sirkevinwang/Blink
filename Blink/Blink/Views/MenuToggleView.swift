//
//  MenuToggleView.swift
//  Blink
//
//  Created by Kevin Wang on 1/5/21.
//

import SwiftUI

struct MenuToggleView: View {
    @ObservedObject var camera: CameraInputController
    var body: some View {
        VStack {
            HStack {
                if (camera.isTracking) {
                    Text("Tracking Eye Blinks")
                } else {
                    Text("Tracking Paused")
                }
                
                Circle()
                    .fill(camera.isTracking ? Color.green : Color.red)
                    .frame(width: 10, height: 10
                           , alignment: .center)
                Spacer()
                Button(action: {
                    if (camera.isTracking) {
                        camera.stop()
                    } else {
                        camera.start()
                    }
                }, label: {
                    if (camera.isTracking) {
                        Text("Stop")
                    } else {
                        Text("Start")
                    }
                    
                })
            }
            .padding(.horizontal, 15)
        }
    }
}

//struct MenuToggleView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuToggleView(isTracking: false)
//            .frame(width: 250.0, height: 50.0, alignment: .center)
//    }
//}

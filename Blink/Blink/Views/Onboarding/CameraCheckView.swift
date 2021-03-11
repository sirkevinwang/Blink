//
//  CameraCheckView.swift
//  Blink
//
//  Created by Kevin Wang on 3/3/21.
//

import SwiftUI
import AVFoundation

struct CameraCheckView: View {
    @Binding var currentOnboardState: OnboardingStates

    var body: some View {
        ZStack {
            VStack {
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Camera Access")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                        Text("We use your camera to track eye blinks.")
                            .font(.title3)
                            .padding(.top, 10)
                            .padding(.bottom, 13)
                        
                        Button(action: {
                            // check for camera privacy settings here
                            let status = AVCaptureDevice.authorizationStatus(for: .video)
                            if status == .authorized {
                                // connect to video device
                                currentOnboardState = .done
                            }
                            
                            if status == .denied {
                                // go to denied page
                                currentOnboardState = .cameraFailed
                                return
                            }
                            
                            AVCaptureDevice.requestAccess(for: .video) { (accessGranted) in
                                if accessGranted {
                                    currentOnboardState = .done
                                } else {
                                    currentOnboardState = .cameraFailed
                                }
                            }
                        }, label: {
                            Text("Allow Access")
                                .font(.body)
                        })
                        
                    }
                    Spacer()
                    Image("WelcomeCameraIcon")
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .center)
                }
                .padding(.horizontal, 60)
                
                Text("Blink doesn't store or upload your camera data. We use on-device machine learning to detect eye blinks.")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray))
                    
            }
        }
        
    }
}


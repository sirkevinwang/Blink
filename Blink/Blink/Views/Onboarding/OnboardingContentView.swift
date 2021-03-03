//
//  OnboardingContentView.swift
//  Blink
//
//  Created by Kevin Wang on 1/11/21.
//

import SwiftUI

struct OnboardingContentView: View {
    @State var onboardingState = OnboardingStates.welcome
    var body: some View {
        switch onboardingState {
        case .welcome:
            WelcomeView()
        case .cameraCheck:
            CameraCheckView()
        case .done:
            WelcomeCompleteView()
        }
    }
}

enum OnboardingStates {
    case welcome
    case cameraCheck
    case done
}

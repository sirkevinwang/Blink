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
            WelcomeView(currentOnboardState: $onboardingState)
        case .cameraCheck:
            CameraCheckView(currentOnboardState: $onboardingState)
        case .done:
            WelcomeCompleteView()
            // Need to call cam.start and construct status menu here
        }
    }
}

enum OnboardingStates {
    case welcome
    case cameraCheck
    case done
}

//
//  OnboardingDataModel.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/03/08.
//

import UIKit

/// 온보딩 화면 구성 위한 모델
struct OnboardingContentData {
    let title: String
    let subtitle: String
    let onboardingImgName: String
    
    func makeImg() -> UIImage? {
        return UIImage(named: onboardingImgName)
    }
}

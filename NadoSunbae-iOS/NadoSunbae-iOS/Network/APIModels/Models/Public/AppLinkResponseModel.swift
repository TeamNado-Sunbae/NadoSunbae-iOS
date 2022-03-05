//
//  AppLinkResponseModel.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/03/05.
//

import Foundation

struct AppLinkResponseModel: Codable {
    var personalInformationPolicy: String
    var termsOfService: String
    var openSourceLicense: String
    var kakaoTalkChannel: String
}

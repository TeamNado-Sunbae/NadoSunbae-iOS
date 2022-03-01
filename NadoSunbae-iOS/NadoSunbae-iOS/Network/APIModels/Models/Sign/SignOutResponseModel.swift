//
//  SignOutResponseModel.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/03/01.
//

import Foundation

struct SignOutResponseModel: Codable {
    var status: Int
    var success: Bool
    var message: String
}

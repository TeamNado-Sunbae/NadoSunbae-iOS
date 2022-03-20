//
//  APIConstants.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import Foundation

struct APIConstants {
    
    // MARK: Base URL
    #if DEBUG
    static let baseURL = "https://asia-northeast3-nadosunbae-server-dev-90ac3.cloudfunctions.net/api"
    #else
    static let baseURL = "https://asia-northeast3-nadosunbae-server.cloudfunctions.net/api"
    #endif
}

//
//  Environment.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/09/11.
//

import Foundation

enum Environment: String {
    case development = "development"
    case qa = "qa"
    case production = "production"
    
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
        }
    }
    
    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else { fatalError() }
        return dict
    }()
}

func env() -> Environment {
    #if DEVELOPMENT
    return .development
    #elseif QA
    return .qa
    #elseif RELEASE
    return .production
    #endif
}

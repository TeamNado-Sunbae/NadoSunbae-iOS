//
//  APIConstants.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/08.
//

import Foundation

struct APIConstants {
    
    // MARK: Base URL
    static let baseURL = Environment.infoDictionary[Environment.Keys.Plist.baseURL] as? String ?? ""
}

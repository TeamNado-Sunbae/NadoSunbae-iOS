//
//  Environment.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/09/11.
//

import Foundation

enum Environment: String {
    case appStoreProduction = "appStoreProduction"
    case development = "development"
}

func env() -> Environment {
    
    /// TestFlight, Xcode
    if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
        return .development
    } else {
        
        /// Simulator
        #if targetEnvironment(simulator)
        return .development
        #else
        return .appStoreProduction
        #endif
    }
}

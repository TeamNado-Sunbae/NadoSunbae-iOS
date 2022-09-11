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
    
    /// TestFlight, Xcode(Device)
    if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
        return .development
    } else {
        
        /// Xcode(Simulator)
        #if targetEnvironment(simulator)
        return .development
        
        /// AppStore
        #else
        return .appStoreProduction
        #endif
    }
}

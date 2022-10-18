//
//  UnivType.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/18.
//

import Foundation

enum UnivType: Int {
    case korea = 1
    case swu = 2
    case cau = 3
}

extension UnivType {
    internal var regardlessMajorID: Int {
        switch self {
        case .korea:
            return 128
        case .swu:
            return 183
        case .cau:
            return 286
        }
    }
}

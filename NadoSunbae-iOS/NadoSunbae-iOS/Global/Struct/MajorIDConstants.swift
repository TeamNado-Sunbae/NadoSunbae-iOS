//
//  MajorIDConstants.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/16.
//

import Foundation

enum MajorIDConstants {
    static let allMajorID = 0
    static let regardlessMajorID = UnivType(rawValue: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID))!.regardlessMajorID
}

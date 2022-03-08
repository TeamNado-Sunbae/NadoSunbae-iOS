//
//  SendBlockedInfoDelegate.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/09.
//

import Foundation

protocol SendBlockedInfoDelegate {
    func sendBlockedInfo(status: Bool, userID: Int)
}

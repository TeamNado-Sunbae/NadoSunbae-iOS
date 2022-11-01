//
//  SendGAEventDelegate.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/11/01.
//

import Foundation

protocol SendGAEventDelegate {
    func sendEvent(eventName: GAEventNameType, parameterValue: String)
}

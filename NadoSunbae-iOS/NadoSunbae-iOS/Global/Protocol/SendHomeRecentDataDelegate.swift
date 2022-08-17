//
//  SendHomeRecentDataDelegate.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import Foundation

protocol SendHomeRecentDataDelegate {
    func sendRecentPostId(id: Int, type: HomeRecentTVCType)
}

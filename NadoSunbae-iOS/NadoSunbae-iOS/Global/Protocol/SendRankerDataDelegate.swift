//
//  SendRankerDataDelegate.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/10/05.
//

import Foundation

protocol SendRankerDataDelegate {
    func sendRankerData(data: HomeRankingResponseModel.UserList)
}

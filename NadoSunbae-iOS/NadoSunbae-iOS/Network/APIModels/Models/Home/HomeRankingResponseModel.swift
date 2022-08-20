//
//  HomeRankingResponseModel.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/14.
//

import Foundation

struct HomeRankingResponseModelElement: Codable {
    var userID: Int = 0
    var profileImageID: Int = 0
    var isOnQuestion: Bool = true
    var nickname: String = ""
    var isFirstMajor: Bool = true
    var responseRate: Int = 0
}

typealias HomeRankingResponseModel = [HomeRankingResponseModelElement]

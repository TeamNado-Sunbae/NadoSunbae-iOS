//
//  ReviewAPI.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import Foundation
import Moya

class ReviewAPI {
    static let shared = ReviewAPI()
    var userProvider = MoyaProvider<ReviewService>(plugins: [NetworkLoggerPlugin()])
}


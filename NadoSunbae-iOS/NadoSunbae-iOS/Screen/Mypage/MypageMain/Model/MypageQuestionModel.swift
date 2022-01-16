//
//  MypageQuestionModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/16.
//

import Foundation

struct MypageQuestionModel: Codable {
    var title: String = ""
    var content: String = ""
    var nickName: String = ""
    var writeTime: String = ""
    var commentCount: Int = 0
    var likeCount: Int = 0
}

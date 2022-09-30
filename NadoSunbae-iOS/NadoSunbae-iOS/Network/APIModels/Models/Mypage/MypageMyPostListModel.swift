//
//  MypageMyPostListModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/18.
//

import Foundation

struct MypageMyPostListModel: Codable {
    var postList: [PostListResModel]

    enum CodingKeys: String, CodingKey {
        case postList = "postList"
    }
}

enum MypageMyPostType: String {
    case personalQuestion = "questionToPerson"
    case community = "community"
}

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

var questionList: [MypageQuestionModel] = [
    MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
    MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
    MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
    MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
    MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
    MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111)
]

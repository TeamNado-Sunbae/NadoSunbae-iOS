//
//  DefaultQuestionDataModel.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/10.
//

import Foundation

struct DefaultQuestionDataModel {
    var isWriter: Bool
    var questionTitle: String
    var nickname: String
    var majorInfo: String
    var contentText: String
}

var defaultQuestionData: [DefaultQuestionDataModel] = [
    DefaultQuestionDataModel(isWriter: true, questionTitle: "질문제목 질문제목", nickname: "원글쓴 닉네임", majorInfo: "본전명 18-1 | 제2전공명 18-1", contentText: "질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 질문내용 ?"),
    DefaultQuestionDataModel(isWriter: false, questionTitle: "", nickname: "타인 닉네임", majorInfo: "본전명 18-1 | 제2전공명 18-1", contentText: "답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용"),
    DefaultQuestionDataModel(isWriter: true, questionTitle: "", nickname: "원글쓴 닉네임", majorInfo: "본전명 18-1 | 제2전공명 18-1", contentText: "답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용"),
    DefaultQuestionDataModel(isWriter: false, questionTitle: "", nickname: "타인 닉네임", majorInfo: "본전명 18-1 | 제2전공명 18-1", contentText: "답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용 답변내용")
]

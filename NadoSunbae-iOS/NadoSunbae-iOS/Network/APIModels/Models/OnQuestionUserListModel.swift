//
//  OnQuestionUserListModel.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import Foundation

struct OnQuestionUserListModel {
    var userId: Int
    var profileImageID: Int
    var isOnQuestion: Bool
    var nickname: String
    var isFirstMajor: Bool
    var majorStart: String
}

struct OffQuestionUserListModel {
    var userId: Int
    var profileImageID: Int
    var isOnQuestion: Bool
    var nickname: String
    var isFirstMajor: Bool
    var majorStart: String
}

var OnQuestionUserList: [OnQuestionUserListModel] = [
    OnQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: true, nickname: "지은", isFirstMajor: true, majorStart: "19-1"),
    OnQuestionUserListModel(userId: 1, profileImageID: 1, isOnQuestion: true, nickname: "지은", isFirstMajor: true, majorStart: "19-1"),
    OnQuestionUserListModel(userId: 1, profileImageID: 2, isOnQuestion: true, nickname: "지은", isFirstMajor: false, majorStart: "19-1"),
    OnQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: true, nickname: "지은", isFirstMajor: true, majorStart: "19-1"),
    OnQuestionUserListModel(userId: 1, profileImageID: 4, isOnQuestion: true, nickname: "지은", isFirstMajor: false, majorStart: "19-1"),
    OnQuestionUserListModel(userId: 1, profileImageID: 3, isOnQuestion: true, nickname: "지은", isFirstMajor: true, majorStart: "19-1"),
    OnQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: true, nickname: "지은", isFirstMajor: false, majorStart: "19-1")
]

var offQuestionUserList: [OffQuestionUserListModel] = [
    OffQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: false, nickname: "지은", isFirstMajor: true, majorStart: "19-1"),
    OffQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: false, nickname: "지은", isFirstMajor: false, majorStart: "19-1"),
    OffQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: false, nickname: "지은", isFirstMajor: true, majorStart: "19-1"),
    OffQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: false, nickname: "지은", isFirstMajor: false, majorStart: "19-1"),
    OffQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: false, nickname: "지은", isFirstMajor: true, majorStart: "19-1"),
    OffQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: false, nickname: "지은", isFirstMajor: false, majorStart: "19-1"),
    OffQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: false, nickname: "지은", isFirstMajor: true, majorStart: "19-1"),
    OffQuestionUserListModel(userId: 1, profileImageID: 0, isOnQuestion: false, nickname: "지은", isFirstMajor: false, majorStart: "19-1")
]

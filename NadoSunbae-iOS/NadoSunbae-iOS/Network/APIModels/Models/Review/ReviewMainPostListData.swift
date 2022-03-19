//
//  ReviewMainPostListData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/20.
//

import Foundation
import UIKit

let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = screenSize.width

// MARK: - ReviewMainPostListData
struct ReviewMainPostListData: Codable {
    let postID: Int
    let oneLineReview: String
    let createdAt: String
    let writer: ReviewWriter
    let tagList: [ReviewTagList]
    let like: Like

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case oneLineReview, createdAt, writer, tagList, like
    }
}

// MARK: - ReviewTagList
struct ReviewTagList: Codable {
    let tagName: String
}

// MARK: - ReviewWriter
struct ReviewWriter: Codable {
    let writerID, profileImageID: Int
    let nickname: String
    let firstMajorName: String
    let firstMajorStart: String
    let secondMajorName: String
    let secondMajorStart: String

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart
    }
}

/// 닉네임 + 전공정보 String으로 반환하는 함수
func convertToUserInfoString(_ nickname: String, _ firstMajorName: String, _ firstMajorStart: String, _ secondMajorName: String, _ secondMajorStart: String) -> String {
    if secondMajorName == "미진입" {
        return nickname + "   " + firstMajorName + " " + firstMajorStart + "  |  " + secondMajorName
    } else {
        /// 닉네임 + 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 32자 넘을 때 (닉네임 텍스트 크기 고려)
        if (nickname.count + firstMajorName.count + firstMajorStart.count + secondMajorName.count + secondMajorStart.count) > 30 {
            
            if screenWidth == 375 {
                /// 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 35자 넘을 때
                if (firstMajorName.count + firstMajorStart.count + secondMajorName.count + secondMajorStart.count) > 35 {
                    return nickname + "\n" + firstMajorName + " " + firstMajorStart + "  |\n" + secondMajorName + " " + secondMajorStart
                } else {
                    /// 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 35자 넘지 않을 때
                    return nickname + "\n" + firstMajorName + " " + firstMajorStart + "  |  " + secondMajorName + " " + secondMajorStart
                }
            } else {
                /// 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 37자 넘을 때
                if (firstMajorName.count + firstMajorStart.count + secondMajorName.count + secondMajorStart.count) > 37 {
                    return nickname + "\n" + firstMajorName + " " + firstMajorStart + "  |\n" + secondMajorName + " " + secondMajorStart
                } else {
                    /// 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 35자 넘지 않을 때
                    return nickname + "\n" + firstMajorName + " " + firstMajorStart + "  |  " + secondMajorName + " " + secondMajorStart
                }
            }
        } else {
            return nickname + "   " + firstMajorName + " " + firstMajorStart + "  |  " + secondMajorName + " " + secondMajorStart
        }
    }
}

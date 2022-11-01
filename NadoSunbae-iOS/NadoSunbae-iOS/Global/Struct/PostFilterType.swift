//
//  PostFilterType.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/08.
//

import Foundation

enum PostFilterType: Int, CaseIterable {
    case community = 0
    case general = 1
    case questionToEveryone = 2 // 전체에게 질문 (커뮤니티 질문)
    case information = 3
    case questionToPerson // 1:1 질문
}

extension PostFilterType {
    var name: String {
        switch self {
        case .community:
            return "전체"
        case .general:
            return "자유"
        case .questionToEveryone:
            return "질문"
        case .information:
            return "정보"
        case .questionToPerson:
            return "1:1 질문"
        }
    }
    
    var postWriteLogEventParameterValue: String {
        switch self {
        case .general:
            return "c_free_upload"
        case .questionToEveryone:
            return "c_question_upload"
        case .information:
            return "c_info_upload"
        case .questionToPerson:
            return "question_1on1_upload"
        default: return ""
        }
    }
}

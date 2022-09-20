//
//  PostFilterType.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/08.
//

import Foundation

enum PostFilterType: CaseIterable {
    case community
    case general
    case questionToEveryone // 전체에게 질문 (커뮤니티 질문)
    case information
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
}

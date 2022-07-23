//
//  CommunityType.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/24.
//

import Foundation

enum CommunityType: Int, CaseIterable {
    case entire = 0
    case freedom = 1
    case question = 2
    case information = 3
}

extension CommunityType {
    var name: String {
        switch self {
        case .entire:
            return "전체"
        case .freedom:
            return "자유"
        case .question:
            return "질문"
        case .information:
            return "정보"
        }
    }
}

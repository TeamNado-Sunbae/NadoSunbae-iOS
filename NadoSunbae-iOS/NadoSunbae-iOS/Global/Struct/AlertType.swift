//
//  AlertType.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/25.
//

import Foundation

enum AlertType {
    case networkError
    case alreadyReported
    case inappropriateReview
    case noPermission
    case forceUpdate
    case softUpdate
    case deletedPost
    case resendMail
}

extension AlertType {
    var alertMessage: String {
        switch self {
            
        case .networkError:
            return "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요."
        case .alreadyReported:
            return "이미 신고한 글/답글입니다."
        case .inappropriateReview:
            return "부적절한 후기 작성이 확인되어\n열람 권한이 제한되었습니다.\n권한을 얻고 싶다면\n다시 학과후기를 작성해주세요."
        case .noPermission:
            return "내 학과 후기를 작성해야\n이용할 수 있는 기능이에요."
        case .forceUpdate:
            return """
            안정적인 서비스 이용을 위해
            최신 버전으로 업데이트해주세요.
            """
        case .softUpdate:
            return  """
            유저들의 의견을 반영하여
            사용성을 개선했어요.
            지금 바로 업데이트해보세요!
            """
        case .deletedPost:
            return "삭제된 게시글입니다."
        case .resendMail:
            return "메일이 재전송되었습니다."
        }
    }
}

//
//  Int+.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation

extension Int {
    
    /// 서버에서 Int로 준 알림 타입을 NotiType으로 반환
    func getNotiType() -> NotiType? {
        switch self {
        case 1: return .mypageQuestion
        case 2: return .writtenQuestion
        case 3: return .writtenInfo
        case 4: return .answerQuestion
        case 5: return .answerInfo
        default:
            print("server Notification type error")
            return nil
        }
    }
    
    /// Univ ID를 해당 학교명 예) "서울여자대학교"로 반환
    func getUnivName() -> String {
        switch self {
        case 1: return "고려대학교"
        case 2: return "서울여자대학교"
        case 3: return "중앙대학교"
        default:
            debugPrint("server univ ID error")
            return "나도선배대학교"
        }
    }
}

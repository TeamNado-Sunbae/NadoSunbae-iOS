//
//  SendUpdateDelegate.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/10.
//

import Foundation

/// 모달 닫힐 때 유용하게 쓸 data 전달 delegate. 데이터 받을 때 타입캐스팅 as? 필수
protocol SendUpdateModalDelegate {
    func sendUpdate(data: Any)
}

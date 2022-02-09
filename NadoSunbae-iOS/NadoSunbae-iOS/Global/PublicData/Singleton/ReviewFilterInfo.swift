//
//  ReviewFilterInfo.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/02/08.
//

import Foundation

class ReviewFilterInfo {
    
    /// 선택된 필터 태그 저장해두기 위한 싱글톤 객체 선언
    static let shared = ReviewFilterInfo()
    
    var selectedBtnList: [Bool] = [false, false, false, false, false, false, false]
    private init() { }
}

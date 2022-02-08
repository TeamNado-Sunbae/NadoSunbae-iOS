//
//  FilterInfo.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/02/08.
//

import Foundation

class FilterInfo {
    
    /// 선택된 필터 태그 저장해두기 위한 싱글톤 객체 선언
    static let shared = FilterInfo()
    
    var selectedBtnList: [Bool] = [false, false, false, false, false, false, false]
    private init() { }
}

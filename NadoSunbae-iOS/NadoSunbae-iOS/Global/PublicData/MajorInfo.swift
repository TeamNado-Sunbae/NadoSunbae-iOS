//
//  MajorInfo.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation

class MajorInfo {
    
    /// 학과 목록 저장해두기 위한 싱글톤 객체 선언
    static let shared = MajorInfo()
    
    var majorList: [String]?
    private init() { }
}

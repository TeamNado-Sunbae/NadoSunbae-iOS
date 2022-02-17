//
//  ReviewImgModel.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit

/// 후기 뷰 메인 이미지 위한 모델
struct ReviewImgData {
    let reviewImgName: String
    
    func makeImg() -> UIImage? {
        return UIImage(named: reviewImgName)
    }
}

/// 후기 작성 뷰 배경 이미지 선택 리스트 위한 모델
struct ReviewWriteBgImgData {
    let bgImgName: String
    
    func makeImg() -> UIImage? {
        return UIImage(named: bgImgName)
    }
}



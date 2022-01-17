//
//  AppContentDataModel.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit

/// 후기 뷰 학과 이름 리스트 위한 모델
struct ReviewData {
    let majorName: String
}

/// 후기 뷰 메인 이미지 위한 모델
struct ReviewImgData {
    let reviewImgName: String
    
    func makeImg() -> UIImage? {
        return UIImage(named: reviewImgName)
    }
}

/// 후기 뷰 메인 게시글 리스트 위한 모델
struct ReviewPostData {
    let date: String
    let title: String
    let diamondCount: Int
    let firstTagImgName: String
    let secondTagImgName: String
    let thirdTagImgName: String
    let majorName: String
    let secondMajorName: String
    
    func makeFirstImg() -> UIImage? {
        return UIImage(named: firstTagImgName)
    }
    
    func makeSecondImg() -> UIImage? {
        return UIImage(named: secondTagImgName)
    }
    
    func makeThirdImg() -> UIImage? {
        return UIImage(named: thirdTagImgName)
    }
}

/// 후기 작성 뷰 배경 이미지 선택 리스트 위한 모델
struct ReviewWriteBgImgData {
    let bgImgName: String
    
    func makeImg() -> UIImage? {
        return UIImage(named: bgImgName)
    }
}

/// 후기 상세 뷰 게시글 리스트 위한 모델
struct ReviewDetailData {
    let iconImgName: String
    let title: String
    let content: String
    
    func makeImg() -> UIImage? {
        return UIImage(named: iconImgName)
    }
}


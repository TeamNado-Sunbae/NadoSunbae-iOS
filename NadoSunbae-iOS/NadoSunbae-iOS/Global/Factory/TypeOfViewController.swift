//
//  TypeOfViewController.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import Foundation

enum TypeOfViewController {
    case tabBar
    case home
    case review
    case classroom
    case community
    case notification
    case mypage
}

extension TypeOfViewController {
    
    func vcRepresentation() -> VCRepresentation {
        switch self {
            
        case .tabBar:
            return VCRepresentation(bundle: nil, storyboardName: "", vcClassName: NadoSunbaeTBC.className)
        case .home:
            return VCRepresentation(bundle: nil, storyboardName: "", vcClassName: HomeNC.className)
        case .review:
            return VCRepresentation(bundle: nil, storyboardName: Identifiers.ReviewSB, vcClassName: ReviewNC.className)
        case .classroom:
            return VCRepresentation(bundle: nil, storyboardName: "", vcClassName: ClassroomNC.className)
        case .community:
            return VCRepresentation(bundle: nil, storyboardName: "", vcClassName: CommunityNC.className)
        case .notification:
            return VCRepresentation(bundle: nil, storyboardName: Identifiers.NotificationSB, vcClassName: NotificationNVC.className)
        case .mypage:
            return VCRepresentation(bundle: nil, storyboardName: Identifiers.MypageSB, vcClassName: MypageNVC.className)
        }
    }
}

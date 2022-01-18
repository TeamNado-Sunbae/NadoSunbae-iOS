//
//  TypeOfViewController.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import Foundation

enum TypeOfViewController {
    case tabBar
    case review
    case classroom
    case notification
    case mypage
}

extension TypeOfViewController {
    
    func storyboardRepresentation() -> StoryboardRepresentation {
        switch self {
            
        case .tabBar:
            return StoryboardRepresentation(bundle: nil, storyboardName: "", storyboardId: NadoSunbaeTBC.className)
        case .review:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.ReviewSB, storyboardId: ReviewNC.className)
        case .classroom:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.ClassroomSB, storyboardId: ClassroomNC.className)
        case .notification:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.NotificationSB, storyboardId: NotificationMainVC.className)
        case .mypage:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.MypageSB, storyboardId: MypageNVC.className)
        }
    }
}

//
//  NadoSunbaeTBC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class NadoSunbaeTBC: UITabBarController {
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarItemStyle()
        configureTabBar()
        applyShadowTabBar()
    }
}

// MARK: - UI
extension NadoSunbaeTBC {
    
    /// 탭바 아이템 생성하는 메서드
    func makeTabVC(vcType: TypeOfViewController, tabBarTitle: String, tabBarImg: String, tabBarSelectedImg: String) -> UIViewController {
        
        let tab = ViewControllerFactory.viewController(for: vcType)
        tab.tabBarItem = UITabBarItem(title: tabBarTitle,
                                      image: UIImage(named: tabBarImg)?.withRenderingMode(.alwaysOriginal),
                                      selectedImage: UIImage(named: tabBarSelectedImg)?.withRenderingMode(.alwaysOriginal))
        tab.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        return tab
    }
    
    /// 탭바 아이템 스타일 설정하는 메서드
    func configureTabBarItemStyle() {
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.PretendardM(size: 12.0),
                                                          NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.PretendardM(size: 12.0)], for: .selected)
    }
    
    /// 탭바 구성하는 메서드
    func configureTabBar() {
        
        let reviewTab = makeTabVC(vcType: .review, tabBarTitle: "후기", tabBarImg: "icReviewGray", tabBarSelectedImg: "icReview")
        let classroomTab = makeTabVC(vcType: .classroom, tabBarTitle: "과방", tabBarImg: "icRoomGray", tabBarSelectedImg: "icRoom")
        let alarmTab = makeTabVC(vcType: .notification, tabBarTitle: "알림", tabBarImg: "icNoticeGray", tabBarSelectedImg: "icNotice")
        let mypageTab = makeTabVC(vcType: .mypage, tabBarTitle: "마이페이지", tabBarImg: "icMypageGray", tabBarSelectedImg: "icMypage")
        
        // 탭 구성
        let tabs =  [reviewTab, classroomTab, alarmTab, mypageTab]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
    
    /// 탭바에 그림자 적용하는 메서드
    func applyShadowTabBar() {
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: UIColor.shadowDefault, alpha: 0.16, x: 0, y: -9, blur: 18)
    }
}

//
//  NadoSunbaeTBC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit
import FirebaseAnalytics

class NadoSunbaeTBC: UITabBarController {
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarItemStyle()
        configureTabBar()
        applyShadowTabBar()
        NotificationCenter.default.addObserver(self, selector: #selector(goToNotificationVC), name: Notification.Name.pushNotificationClicked, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.pushNotificationClicked, object: nil)
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
        
        tabBar.tintColor = .black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.PretendardM(size: 12.0)], for: .normal)
    }
    
    /// 탭바 구성하는 메서드
    func configureTabBar() {
        
        let homeTab = makeTabVC(vcType: .home, tabBarTitle: "홈", tabBarImg: "icHomeGray", tabBarSelectedImg: "icHome")
        let classroomTab = makeTabVC(vcType: .classroom, tabBarTitle: "과방", tabBarImg: "icClassroomGray", tabBarSelectedImg: "icClassroom")
        let communityTab = makeTabVC(vcType: .community, tabBarTitle: "커뮤니티", tabBarImg: "icCommunityGray", tabBarSelectedImg: "icCommunity")
        let alarmTab = makeTabVC(vcType: .notification, tabBarTitle: "알림", tabBarImg: "icNoticeGray", tabBarSelectedImg: "icNotice")
        let mypageTab = makeTabVC(vcType: .mypage, tabBarTitle: "마이", tabBarImg: "icMypageGray", tabBarSelectedImg: "icMypage")
        
        // 탭 구성
        let tabs = [homeTab, classroomTab, communityTab, alarmTab, mypageTab]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
    
    /// 탭바에 그림자 적용하는 메서드
    func applyShadowTabBar() {
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: UIColor.shadowDefault, alpha: 0.16, x: 0, y: -9, blur: 18)
    }
}

// MARK: - Custom Methods
extension NadoSunbaeTBC {
    
    /// foreground로 알림을 클릭했을 때 실행되는 메서드
    @objc
    private func goToNotificationVC() {
        
        /// 탭바에서 NotificationCenter Observer를 활용하여 푸시를 클릭했을 때 탭바의 selectedIndex를 2로, 싱글톤 객체의 값을 false로 변경
        NotificationInfo.shared.isPushComes = false
        self.selectedIndex = 2
    }
}

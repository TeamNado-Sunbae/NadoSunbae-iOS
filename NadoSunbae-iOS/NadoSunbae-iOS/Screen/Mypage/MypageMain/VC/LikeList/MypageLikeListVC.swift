//
//  MypageLikeListVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/07.
//

import UIKit
import SnapKit
import Then

class MypageLikeListVC: BaseVC {
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbar()
    }
}

// MARK: - UI
extension MypageLikeListVC {
    private func configureUI() {
        
    }
}

// MARK: - SendSegmentStateDelegate
extension MypageLikeListVC: SendSegmentStateDelegate {
    func sendSegmentClicked(index: Int) {
        if index == 0 {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageReviewLikeVC")
        } else if index == 1 {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageQuestionLikeVC")
        } else {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageInfoLikeVC")
        }
    }
}

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
    
    // MARK: Components
    private lazy var naviView = NadoSunbaeNaviBar().then {
        $0.configureTitleLabel(title: "좋아요 목록")
        $0.setUpNaviStyle(state: .backDefault)
        $0.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private let likeListSegmentControl = NadoSegmentedControl(items: ["후기", "1:1 질문", "커뮤니티"])
    private let likeListSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    private let likeListTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.contentInset = .zero
        $0.separatorColor = .gray0
        $0.isScrollEnabled = false
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        likeListSegmentControl.setUpNadoSegmentFrame()
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

// MARK: - UI
extension MypageLikeListVC {
    private func configureUI() {
        view.backgroundColor = .bgGray
        
        view.addSubviews([naviView, likeListSegmentControl, likeListSV])
        likeListSV.addSubview(contentView)
        contentView.addSubview(likeListTV)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        likeListSegmentControl.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(240)
        }
        
        likeListSV.snp.makeConstraints {
            $0.top.equalTo(likeListSegmentControl.snp.bottom).offset(18)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        likeListTV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(13)
        }
    }
}

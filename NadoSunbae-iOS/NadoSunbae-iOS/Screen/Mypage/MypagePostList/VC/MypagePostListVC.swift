//
//  MypagePostListVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/14.
//

import UIKit

class MypagePostListVC: BaseVC {
    
    // MARK: Components
    private lazy var naviView = NadoSunbaeNaviBar().then {
        $0.configureTitleLabel(title: "내가 쓴 글")
        $0.setUpNaviStyle(state: .backDefault)
        $0.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBOutlet weak var postListContainerView: NadoHorizonContainerViews! {
        didSet {
            postListContainerView.setMultiplier(containerCount: 2)
        }
    }
    
    // MARK: Properties
    var isPostOrAnswer = true

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: MypagePostListVC.className)
    }
}

// MARK: - UI
extension MypagePostListVC {
    private func configureContainerView() {
        guard let mypageQuestionListVC = storyboard?.instantiateViewController(withIdentifier: MypageMyPostListVC.className) as? MypageMyPostListVC else { return }
        guard let mypageInfoListVC = storyboard?.instantiateViewController(withIdentifier: MypageMyPostListVC.className) as? MypageMyPostListVC else { return }
        
        mypageQuestionListVC.isPostOrAnswer = isPostOrAnswer
        mypageInfoListVC.isPostOrAnswer = isPostOrAnswer
        mypageInfoListVC.postType = .information
        mypageQuestionListVC.sendSegmentStateDelegate = self
        mypageInfoListVC.sendSegmentStateDelegate = self
        
        mypageQuestionListVC.view.frame = self.view.bounds
        mypageInfoListVC.view.frame = self.view.bounds
        
        addChild(mypageQuestionListVC)
        addChild(mypageInfoListVC)
        
        mypageQuestionListVC.view.translatesAutoresizingMaskIntoConstraints = false
        mypageInfoListVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        postListContainerView.firstContainerView.addSubview(mypageQuestionListVC.view)
        postListContainerView.secondContainerView.addSubview(mypageInfoListVC.view)
        
        mypageQuestionListVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.postListContainerView)
        }
        
        mypageInfoListVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(postListContainerView.secondContainerView)
        }
        
        mypageQuestionListVC.didMove(toParent: self)
    }
}

extension MypagePostListVC: SendSegmentStateDelegate {
    func sendSegmentClicked(index: Int) {
        if index == 0 {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: MypageMyPostListVC.className)
            postListContainerView.externalSV.contentOffset.x = 0
        } else {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyPostAnswerListVC")
            postListContainerView.externalSV.contentOffset.x += screenWidth
        }
    }
}

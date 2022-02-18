//
//  MypagePostListVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/14.
//

import UIKit

class MypagePostListVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.configureTitleLabel(title: isPostOrAnswer ? "내가 쓴 글" : "내가 쓴 답글")
            navView.setUpNaviStyle(state: .backDefault)
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBOutlet weak var postListContainerView: NadoHorizonContainerViews!
    
    // MARK: Properties
    var isPostOrAnswer = true
    private let screenWidth = UIScreen.main.bounds.size.width

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
    }
}

// MARK: - UI
extension MypagePostListVC {
    private func configureContainerView() {
        guard let mypageQuestionListVC = storyboard?.instantiateViewController(withIdentifier: MypageMyPostListVC.className) as? MypageMyPostListVC else { return }
        guard let mypageInfoListVC = storyboard?.instantiateViewController(withIdentifier: MypageMyPostListVC.className) as? MypageMyPostListVC else { return }
        
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
            postListContainerView.externalSV.contentOffset.x = 0
        } else {
            postListContainerView.externalSV.contentOffset.x += screenWidth
        }
    }
}

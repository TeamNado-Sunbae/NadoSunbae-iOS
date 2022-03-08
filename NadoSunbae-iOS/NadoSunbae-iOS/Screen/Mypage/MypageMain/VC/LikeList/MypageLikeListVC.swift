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
    
    // MARK: Properties
    private var likeContainerView = NadoHorizonContainerViews().then {
        $0.setMultiplier(containerCount: 3)
    }
    
    // MARK: IBOutlet
    @IBOutlet var topNaviView: NadoSunbaeNaviBar! {
        didSet {
            topNaviView.configureTitleLabel(title: "좋아요 목록")
            topNaviView.setUpNaviStyle(state: .backDefault)
            topNaviView.backBtn.press {
                    self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
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
        self.view.backgroundColor = .paleGray
        self.view.addSubview(likeContainerView)
        likeContainerView.snp.makeConstraints {
            $0.top.equalTo(topNaviView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    /// containerView 컨텐츠 VC를 설정하는 메서드
    func configureContainerView() {
        let likeReviewVC = MypageReviewLikeVC()
        let likeQuestionVC = MypageClassroomPostListVC()
        let likeInfoVC = MypageClassroomPostListVC()
        likeInfoVC.likePostType = .information
        
        likeReviewVC.sendSegmentStateDelegate = self
        likeQuestionVC.sendSegmentStateDelegate = self
        likeInfoVC.sendSegmentStateDelegate = self
        
        [likeReviewVC, likeQuestionVC, likeInfoVC].forEach {
            addChild($0)
            $0.view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        /// 세번째 containerView를 만들어 ContainerView의 containerStack의 서브뷰로 add
        let thirdContainerView = UIView()
        likeContainerView.containerStackView.addArrangedSubview(thirdContainerView)
        
        likeContainerView.firstContainerView.addSubview(likeReviewVC.view)
        likeContainerView.secondContainerView.addSubview(likeQuestionVC.view)
        thirdContainerView.addSubview(likeInfoVC.view)
        
        likeReviewVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.likeContainerView)
        }
        
        likeQuestionVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(likeContainerView.secondContainerView)
        }
        
        likeInfoVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(thirdContainerView)
        }
        
        likeReviewVC.didMove(toParent: self)
    }
}

// MARK: - SendSegmentStateDelegate
extension MypageLikeListVC: SendSegmentStateDelegate {
     
    /// segment가 클릭되면 index에 따라 ContainerView의 ContentOffset.x 좌표를 바꿔주는 메서드
    func sendSegmentClicked(index: Int) {
        let contentOffsetX = likeContainerView.externalSV.contentOffset.x
        
        if index == 0 {
            likeContainerView.externalSV.contentOffset.x = 0
        } else if index == 1 {
            if contentOffsetX > screenWidth {
                likeContainerView.externalSV.contentOffset.x -= screenWidth
            } else {
                likeContainerView.externalSV.contentOffset.x += screenWidth
            }
        } else {
            if contentOffsetX == screenWidth {
                likeContainerView.externalSV.contentOffset.x += screenWidth
            } else {
                likeContainerView.externalSV.contentOffset.x += screenWidth * 2
            }
        }
    }
}

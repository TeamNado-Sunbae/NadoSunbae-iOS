//
//  ClassroomMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then

class ClassroomMainVC: UIViewController {
    
    // MARK: Properties
    private let screenWidth = UIScreen.main.bounds.size.width
    private let majorLabel = UILabel().then {
        // TODO: text Userdefaults선배 값으로 바꿀 예정
        $0.text = "국어국문학과"
        $0.font = .PretendardM(size: 20)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    private let bottomArrowImgView = UIImageView().then {
        $0.image = UIImage(named: "btnArrow")
    }
    
    private let majorSelectBtn = UIButton()
    
    // MARK: IBOutlet
    @IBOutlet var topNaviView: UIView!
    private let classroomContainerView = NadoHorizonContainerViews()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .paleGray
        configureUI()
        tapMajorSelectBtn()
        configureContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - UI
extension ClassroomMainVC {
    private func configureUI() {
        topNaviView.addSubviews([majorLabel, bottomArrowImgView, majorSelectBtn])
        self.view.addSubview(classroomContainerView)
        
        majorLabel.snp.makeConstraints {
            $0.bottom.equalTo(topNaviView.snp.bottom).offset(-24)
            $0.leading.equalTo(topNaviView.snp.leading).offset(16)
        }
        
        bottomArrowImgView.snp.makeConstraints {
            $0.height.width.equalTo(48)
            $0.leading.equalTo(majorLabel.snp.trailing)
            $0.centerY.equalTo(majorLabel)
        }
        
        majorSelectBtn.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(bottomArrowImgView)
            $0.leading.equalTo(majorLabel)
        }
        
        classroomContainerView.snp.makeConstraints {
            $0.top.equalTo(topNaviView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    /// containerView 컨텐츠 VC를 설정하는 메서드
    func configureContainerView() {
        let questionSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionSB, bundle: nil)
        let infoSB: UIStoryboard = UIStoryboard(name: Identifiers.InfoSB, bundle: nil)

        guard let questionMainVC = questionSB.instantiateViewController(identifier: QuestionMainVC.className) as? QuestionMainVC else { return }
        guard let infoMainVC = infoSB.instantiateViewController(identifier: InfoMainVC.className) as? InfoMainVC else { return }
        
        questionMainVC.sendSegmentStateDelegate = self
        infoMainVC.sendSegmentStateDelegate = self
        
        [questionMainVC, infoMainVC].forEach {
            addChild($0)
            $0.view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        classroomContainerView.firstContainerView.addSubview(questionMainVC.view)
        classroomContainerView.secondContainerView.addSubview(infoMainVC.view)
        
        questionMainVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.classroomContainerView)
        }
        
        infoMainVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(classroomContainerView.secondContainerView)
        }
        
        questionMainVC.didMove(toParent: self)
    }
}

// MARK: - Custom Methods
extension ClassroomMainVC {
    
    /// HalfModalView를 present하는 메서드
    private func presentHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    /// 전공 선택 버튼을 tap했을 때 메서드
    private func tapMajorSelectBtn() {
        majorSelectBtn.press(vibrate: true) {
            self.presentHalfModalView()
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ClassroomMainVC: UIViewControllerTransitioningDelegate {
    
    /// presentationController - forPresented
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - SendSegmentStateDelegate
extension ClassroomMainVC: SendSegmentStateDelegate {
     
    /// segment가 클릭되면 index에 따라 ContainerView의 ContentOffset.x 좌표를 바꿔주는 메서드
    func sendSegmentClicked(index: Int) {
        if index == 0 {
            classroomContainerView.externalSV.contentOffset.x = 0
        } else {
            classroomContainerView.externalSV.contentOffset.x += screenWidth
        }
    }
}

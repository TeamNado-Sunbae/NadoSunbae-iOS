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
    private let majorLabel = UILabel().then {
        // TODO: Userdefaults선배 값으로 바꿀 예정
        $0.text = "국어국문학과"
        $0.font = .PretendardM(size: 20)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    private let bottomArrowImgView = UIImageView().then {
        $0.image = UIImage(named: "btnArrow")
    }
    
    private let majorSelectBtn = UIButton()
    
    @IBOutlet var topNaviView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tapMajorSelectBtn()
    }
}

// MARK: - UI
extension ClassroomMainVC {
    private func configureUI() {
        topNaviView.addSubviews([majorLabel, bottomArrowImgView, majorSelectBtn])
        
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
        majorSelectBtn.press {
            self.presentHalfModalView()
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ClassroomMainVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

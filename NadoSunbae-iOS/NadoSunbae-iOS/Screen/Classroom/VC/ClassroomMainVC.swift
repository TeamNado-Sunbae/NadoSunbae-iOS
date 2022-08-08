//
//  ClassroomMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then
import FirebaseAnalytics

class ClassroomMainVC: BaseVC {
    
    // MARK: Properties
    private let majorLabel = UILabel().then {
        $0.text = UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)
        $0.font = .PretendardM(size: 20)
        $0.textColor = .black
        $0.sizeToFit()
    }

    private let bottomArrowImgView = UIImageView().then {
        $0.image = UIImage(named: "btnArrow")
    }

    private let majorSelectBtn = UIButton()
    private let classroomTV = UITableView()
    
    // MARK: IBOutlet
    @IBOutlet var topNaviView: UIView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tapMajorSelectBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpMajorLabel()
        showTabbar()
        makeScreenAnalyticsEvent(screenName: "ClassRoom Tab", screenClass: ClassroomMainVC.className)
    }
}

// MARK: - UI
extension ClassroomMainVC {
    private func configureUI() {
        topNaviView.addSubviews([majorLabel, bottomArrowImgView, majorSelectBtn])
        self.view.addSubview(classroomTV)
        self.view.backgroundColor = .paleGray
        
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
        
        classroomTV.snp.makeConstraints {
            $0.top.equalTo(topNaviView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
        slideVC.selectMajorDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    /// 전공 선택 버튼을 tap했을 때 메서드
    private func tapMajorSelectBtn() {
        majorSelectBtn.press(vibrate: true) {
            self.presentHalfModalView()
        }
    }
    
    /// 전공 Label text를 set하는 메서드
    private func setUpMajorLabel() {
        majorLabel.text = (MajorInfo.shared.selectedMajorName != nil) ? MajorInfo.shared.selectedMajorName : UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ClassroomMainVC: UIViewControllerTransitioningDelegate {
    
    /// presentationController - forPresented
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - SendUpdateModalDelegate
extension ClassroomMainVC: SendUpdateModalDelegate {
    func sendUpdate(data: Any) {
        majorLabel.text = data as? String
    }
}

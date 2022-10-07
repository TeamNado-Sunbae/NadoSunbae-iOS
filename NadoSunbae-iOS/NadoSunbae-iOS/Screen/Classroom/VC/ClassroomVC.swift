//
//  ClassroomVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/07.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class ClassroomVC: BaseVC {
    
    // MARK: Properties
    private let classroomSV = UIScrollView()
    private let contentView = UIView()
    private let majorLabel = UILabel().then {
        $0.text = UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)
        $0.font = .PretendardM(size: 20)
        $0.textColor = .black
        $0.sizeToFit()
    }

    private let bottomArrowImgView = UIImageView().then {
        $0.image = UIImage(named: "btnArrow")
    }

    private let topMajorSelectView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let majorSelectBtn = UIButton()
    private let reviewImageContainerView = UIView()
    private let reviewImageView = UIImageView().then {
        $0.image = UIImage(named: "Frame 149")
        $0.contentMode = .scaleAspectFill
    }
    
    private let reviewTitleLabel = UILabel().then {
        $0.text = "내 학과 후기를 쓰고\n서로 간에 도움을\n주고받아요"
        $0.numberOfLines = 0
        $0.textColor = .reviewTitleColor
        $0.font = .PretendardB(size: 21.0)
        $0.sizeToFit()
    }

    
    private let reviewSubTitleLabel = UILabel().then {
        $0.text = "후기 작성 시 전체 학과 후기 열람 가능"
        $0.textColor = .reviewSubTitleColor
        $0.font = .PretendardR(size: 12.0)
    }
    
    private let segmentedControlContainerView = UIView()
    private let segmentedControl = NadoSegmentedControl(items: ["후기", "1:1 질문"])
    private let contentVCContainerView = UIView()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addShadowToTopMajorSelectView()
        tapMajorSelectBtn()
        setUpDelegate()
    }
}

// MARK: - UI
extension ClassroomVC {
    
    /// UI 구성하는 메서드
    private func configureUI() {
        self.view.backgroundColor = .paleGray
        view.addSubviews([reviewImageContainerView, classroomSV, segmentedControlContainerView, topMajorSelectView])
        classroomSV.addSubview(contentView)
        contentView.addSubviews([contentVCContainerView])
        
        topMajorSelectView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        reviewImageContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(104)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(192)
        }
        
        segmentedControlContainerView.snp.makeConstraints {
            $0.top.equalTo(reviewImageContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        classroomSV.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
        }
        
        contentVCContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(352)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        configureTopMajorSelectView()
        configureReviewImageContainerView()
        configureSegmentedControlContainerView()
    }
    
    /// topMajorSelectView UI 구성 메서드
    private func configureTopMajorSelectView() {
        topMajorSelectView.addSubviews([majorLabel, bottomArrowImgView, majorSelectBtn])
        
        majorLabel.snp.makeConstraints {
            $0.bottom.equalTo(topMajorSelectView.snp.bottom).offset(-24)
            $0.leading.equalTo(topMajorSelectView.snp.leading).offset(16)
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
    
    /// reviewImageContainerView UI 구성 메서드
    private func configureReviewImageContainerView() {
        reviewImageContainerView.addSubviews([reviewImageView, reviewTitleLabel, reviewSubTitleLabel])
        
        reviewImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        reviewTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalToSuperview().offset(16)
        }
        
        reviewSubTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(18)
            $0.leading.equalTo(reviewTitleLabel)
        }
    }
    
    /// segmentedContolContainerView UI 구성 메서드
    private func configureSegmentedControlContainerView() {
        segmentedControlContainerView.backgroundColor = .white
        segmentedControlContainerView.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(160)
            $0.height.equalTo(36)
        }
    }
    
    /// topMajorSelectView dropShadow 설정 메서드
    private func addShadowToTopMajorSelectView() {
        topMajorSelectView.layer.shadowColor = UIColor(red: 0.898, green: 0.898, blue: 0.91, alpha: 0.16).cgColor
        topMajorSelectView.layer.shadowOffset = CGSize(width: 0, height: 9)
        topMajorSelectView.layer.shadowRadius = 18
        topMajorSelectView.layer.shadowOpacity = 1
        topMajorSelectView.layer.masksToBounds = false
    }
}

// MARK: - Custom Methods
extension ClassroomVC {
    
    /// HalfModalView를 present하는 메서드
    private func presentHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.vcType = .search
        slideVC.cellType = .star
        slideVC.hasNoMajorOption = false
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
    
    /// delegate 대리자 위임 메서드
    private func setUpDelegate() {
        classroomSV.delegate = self
    }
}

// MARK: - UIScrollViewDelegate
extension ClassroomVC: UIScrollViewDelegate {
    
    /// scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        /// yOffset이 192보다 크거나 같을 때
        // ❕192는 위로 스크롤되면 사라질 reviewImageContainerView의 height값
        if yOffset >= 192 {
            
            // ✅ 상단고정 효과: segmentedControlContainerView
            segmentedControlContainerView.snp.remakeConstraints {
                $0.top.equalTo(topMajorSelectView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(56)
            }
        } else {
            reviewImageContainerView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(yOffset < 0 ? 104 : 104 - yOffset)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(192)
            }
            
            segmentedControlContainerView.snp.remakeConstraints {
                $0.top.equalTo(reviewImageContainerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(56)
            }
        }
        
        // yOffset이 음수값이면 0으로 설정
        scrollView.contentOffset.y = yOffset < 0 ? 0 : yOffset
        
        // yOffset이 양수값일 때만 scrollView의 bounces를 true로 설정
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ClassroomVC: UIViewControllerTransitioningDelegate {
    
    /// presentationController - forPresented
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - SendUpdateModalDelegate
extension ClassroomVC: SendUpdateModalDelegate {
    func sendUpdate(data: Any) {
        majorLabel.text = data as? String
    }
}

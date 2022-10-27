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
import RxSwift

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
    private lazy var filterBtn = UIButton().then {
        $0.setImgByName(name: "btnFilter", selectedName: "filterSelected")
    }
    
    private let arrangeBtn = UIButton().then {
        $0.setImgByName(name: "btnArray", selectedName: "btnArray")
    }
    
    private let contentVCContainerView = UIView()
    private let reviewWriteBtn = UIButton().then {
        $0.setImgByName(name: "reviewFloatingBtn", selectedName: "reviewFloatingBtn")
        $0.contentMode = .scaleAspectFill
    }
    
    private var reviewVC: ReviewVC = ReviewVC()
    private var personalQuestionVC: PersonalQuestionVC = PersonalQuestionVC()
    private let loadingDispatchGroup = DispatchGroup()
    private var segmentChangeActionStatus: Bool = false
    private var filterStatus = false
    private var selectedWriterFilter: ReviewWriterType = .all
    private var selectedTagFilter = "1, 2, 3, 4, 5"
    
    var disposeBag = DisposeBag()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addShadowToTopMajorSelectView()
        tapMajorSelectBtn()
        setUpDelegate()
        bindAction()
        injectReactor()
        tapReviewWriteBtnAction()
        self.addChild(reviewVC)
        self.addChild(personalQuestionVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabbar()
    }
}

// MARK: - Bind
extension ClassroomVC {
    private func bindAction() {
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] selectIndex in
                self?.hideFilterArrangeBtn(isHidden: selectIndex == 0 ? false : true)
                self?.configureContentVCBySegmentIndex(by: selectIndex)
            })
            .disposed(by: disposeBag)
        
        filterBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentFilterView()
            })
            .disposed(by: disposeBag)
        
        arrangeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentArrangeActionSheet()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension ClassroomVC {
    
    /// UI 구성하는 메서드
    private func configureUI() {
        self.view.backgroundColor = .paleGray
        view.addSubviews([reviewImageContainerView, classroomSV, segmentedControlContainerView, topMajorSelectView, reviewWriteBtn, activityIndicator])
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
            $0.width.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        reviewWriteBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.layoutMarginsGuide).inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(64)
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
        segmentedControlContainerView.addSubviews([segmentedControl, filterBtn, arrangeBtn])
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(160)
            $0.height.equalTo(36)
        }
        
        arrangeBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(segmentedControl)
            $0.width.equalTo(68)
            $0.height.equalTo(24)
        }
        
        filterBtn.snp.makeConstraints {
            $0.trailing.equalTo(arrangeBtn.snp.leading).offset(-12)
            $0.centerY.equalTo(segmentedControl)
            $0.width.equalTo(48)
            $0.height.equalTo(24)
        }
    }
    
    /// contentVCContainerView UI 구성 메서드
    private func configureContentVCContainerView(VC: UIViewController) {
        let oppositeVC = VC == reviewVC ? personalQuestionVC : reviewVC
        
        if self.children.count > 0 {
            oppositeVC.willMove(toParent: nil)
            oppositeVC.removeFromParent()
            oppositeVC.view.removeFromSuperview()
        }
        
        addChild(VC)
        VC.viewWillLayoutSubviews()
        VC.didMove(toParent: self)
        contentVCContainerView.addSubview(VC.view ?? UIView())
    }
    
    /// segmentedControl의 selectedIndex에 따른 VC 구성 메서드
    private func configureContentVCBySegmentIndex(by segmentIndex: Int) {
        segmentChangeActionStatus = true
        
        switch segmentIndex {
        case 0:
            configureContentVCContainerView(VC: reviewVC)
            reviewVC.contentSizeDelegate = self
            reviewVC.loadingDelegate = self
            reviewWriteBtn.isHidden = false
        case 1:
            configureContentVCContainerView(VC: personalQuestionVC)
            personalQuestionVC.contentSizeDelegate = self
            personalQuestionVC.loadingDelegate = self
            reviewWriteBtn.isHidden = true
        default:
            print("segment default")
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
    
    /// 필터 바텀시트를 present하는 메서드
    private func presentFilterView() {
        let slideVC = FilterVC()
        slideVC.selectFilterDelegate = self
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    /// 정렬 기준 선택 액션시트 present하는 메서드
    private func presentArrangeActionSheet() {
        makeTwoAlertWithCancel(okTitle: "최신순", secondOkTitle: "좋아요순", okAction: { _ in
            self.arrangeBtn.setImage(UIImage(named: "btnArray"), for: .normal)
            self.reviewVC.reactor?.sortType = .recent
            NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
        }, secondOkAction: { _ in
            self.arrangeBtn.setImage(UIImage(named: "property1Variant3"), for: .normal)
            self.reviewVC.reactor?.sortType = .like
            NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
        })
    }
    
    /// 전공 선택 버튼을 tap했을 때 메서드
    private func tapMajorSelectBtn() {
        majorSelectBtn.press(vibrate: true) { [weak self] in
            self?.presentHalfModalView()
            NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
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
    
    /// filterBtn, arrangeBtn 숨기는 메서드
    private func hideFilterArrangeBtn(isHidden: Bool) {
        [filterBtn, arrangeBtn].forEach {
            $0?.isHidden = isHidden
        }
    }
    
    /// reactor를 주입하는 메서드
    private func injectReactor() {
        personalQuestionVC.reactor = PersonalQuestionReactor()
        reviewVC.reactor = ReviewReactor()
    }
    
    /// 후기 작성 플로팅 버튼 Action 설정 메서드
    private func tapReviewWriteBtnAction() {
        reviewWriteBtn.press { [weak self] in
            guard let self = self else { return }
            self.navigator?.instantiateVC(destinationViewControllerType: ReviewWriteVC.self, useStoryboard: true, storyboardName: "ReviewWriteSB", naviType: .present, modalPresentationStyle: .fullScreen) { destination in }
        }
    }
    
    /// loadingDispatchGroup의 count가 0이 되었음을 알리는 메서드
    private func notifyLoadingDispatchGroupFinished() {
        loadingDispatchGroup.notify(queue: DispatchQueue.main) {
            self.activityIndicator.stopAnimating()
        }
    }
    
    /// contentVCContainerView의 높이값을 기반으로 classroomSV의 contentOffset의 y좌표를 설정하는 메서드
    private func setClassroomSVContentYOffsetByHeight(height: CGFloat) {
        let contentYOffset = classroomSV.contentOffset.y
        
        // yOffset이 192보다 크거나 같을 때
        // 스크롤되어 segmentedControlContainerView가 네비게이션 뷰 bottom에 닿았을 때
        if contentYOffset >= 192 {
            
            // 만약 contentVCContainerView의 높이값 + 352(top ~ segmentedControlContainerView bottom까지의 높이 값)가 스크린의 height값보다 크다면
            // classroomSV contentOffset의 y좌표를 192로 설정 -> segmentedControlContainerView가 상단 고정된 상태 유지
            
            // 만약 작다면
            // classroomSV contentOffset의 y좌표를 0으로 설정
            classroomSV.contentOffset.y = 352 + height > UIScreen.main.bounds.height ? 192 : 0
        }
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
        segmentChangeActionStatus = true
    }
}

// MARK: - SendUpdateStatusDelegate
extension ClassroomVC: SendUpdateStatusDelegate {
    func sendStatus(data: Bool) {
        let selectedList = ReviewFilterInfo.shared.selectedBtnList
        
        /// 필터 on/off 판단
        filterStatus = data
        
        /// 태그 필터 초기화
        var selectedTagList: [String] = []
        
        /// 작성자 필터 판단
        if selectedList[0] == true  && selectedList[1] == false {
            selectedWriterFilter = .firstMajor
        } else if selectedList[0] == false && selectedList[1] == true {
            selectedWriterFilter = .secondMajor
        } else {
            selectedWriterFilter = .all
        }
        
        /// 태그 필터 판단
        for i in 2...selectedList.count - 1 {
            if selectedList[i] == true {
                selectedTagList.append(String(i - 1))
                selectedTagFilter = selectedTagList.joined(separator: ", ")
            }
        }
        
        if filterStatus {
            /// 필터 on 상태일 때
            filterBtn.setImage(UIImage(named: "filterSelected"), for: .normal)
            reviewVC.reactor?.writerType = selectedWriterFilter
            reviewVC.reactor?.tagFilter = selectedTagFilter
        } else {
            /// 필터 off 상태일 때
            filterBtn.setImage(UIImage(named: "btnFilter"), for: .normal)
            reviewVC.reactor?.writerType = .all
            reviewVC.reactor?.tagFilter = "1, 2, 3, 4, 5"
        }
    }
}

// MARK: - SendContentSizeDelegate
extension ClassroomVC: SendContentSizeDelegate {
    func sendContentSize(height: CGFloat, comeFrom: String) {
        if comeFrom == reviewVC.className && segmentedControl.selectedSegmentIndex == 0 || comeFrom == personalQuestionVC.className && segmentedControl.selectedSegmentIndex == 1 {
            
            if segmentChangeActionStatus {
                setClassroomSVContentYOffsetByHeight(height: height)
                segmentChangeActionStatus = false
            }
            
            let screenHeight = UIScreen.main.bounds.height
            let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
            var contentVCHeight: CGFloat?
            
            // 컨텐츠 영역이 tabBar에 가려져서 컨텐츠 영역이 제대로 보여지지 않는 경우
            if height < screenHeight && height + 352 > screenHeight - tabBarHeight {
                contentVCHeight = height + 47
            }
            
            [reviewVC, personalQuestionVC].forEach {
                $0.view.frame.size = CGSize(width: contentVCContainerView.frame.width, height: contentVCHeight ?? height)
            }
                
            contentVCContainerView.snp.updateConstraints {
                $0.height.equalTo(contentVCHeight ?? height)
            }
        }
    }
}

// MARK: - SendLoadingStatusDelegate
extension ClassroomVC: SendLoadingStatusDelegate {
    func sendLoadingStatus(loading: Bool) {
        let dispatchCount = self.loadingDispatchGroup.debugDescription.components(separatedBy: ",").filter({ $0.contains("count") }).first?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap({ Int($0)} ).first ?? 0
        
        if loading {
            self.activityIndicator.startAnimating()
            loadingDispatchGroup.enter()
        } else {
            if dispatchCount > 0 {
                self.loadingDispatchGroup.leave()
            }
        }
        
        self.notifyLoadingDispatchGroupFinished()
    }
}

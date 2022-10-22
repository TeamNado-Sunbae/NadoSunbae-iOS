//
//  CommunityWriteVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/24.
//

import UIKit
import ReactorKit
import RxCocoa

protocol SendPostTypeDelegate {
    func sendPostType(postType: PostFilterType)
}

final class CommunityWriteVC: BaseWritePostVC, View {
    
    // MARK: Components
    private let selectMajorLabel = UILabel().then {
        $0.text = "학과 선택"
    }
    
    private let majorSelectTextField = NadoTextField().then {
        $0.setSelectStyle()
        $0.setText(text: "학과 무관")
    }
    
    private let majorSelectBtn = UIButton()
    
    private let categoryLabel = UILabel().then {
        $0.text = "카테고리"
    }
    
    private let categoryCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let questionDescLabel = UILabel().then {
        $0.text = "특정 학과 선택시 해당 학과 유저들에게 알림이 갑니다."
        $0.font = .PretendardR(size: 12.0)
        $0.textColor = .mainDark
        $0.isHidden = true
    }
    
    private let partitionBar = UIView().then {
        $0.backgroundColor = .gray0
    }
    
    private var selectedCategory: PostFilterType = .general
    
    private let nadoAlert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: CommunityWriteVC.self, options: nil)?.first as? NadoAlertVC
    
    var disposeBag = DisposeBag()
    var isEditState: Bool = false
    var postID: Int?
    var majorID: Int?
    var categoryIndex: Int?
    var originTitle: String?
    var originContent: String?
    var originMajor: String?
    var sendPostTypeDelegate: SendPostTypeDelegate?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        configureUI()
        configureLabel()
        setUpInitAction()
        registerCell()
        setUpInitStyle()
        setUpAlertMsgByEditState()
        setUpCategoryCVByEditState()
        setHighlightViewState(textField: questionTitleTextField, highlightView: textHighlightView)
        setActivateBtnState(textField: questionTitleTextField, textView: questionWriteTextView)
    }
    
    func bind(reactor: CommunityWriteReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - UI
extension CommunityWriteVC {
    private func configureUI() {
        view.backgroundColor = .white
        contentView.addSubviews([selectMajorLabel, majorSelectTextField, majorSelectBtn, categoryLabel, categoryCV, questionDescLabel, partitionBar])
        
        selectMajorLabel.snp.makeConstraints {
            $0.top.equalTo(questionWriteNaviBar.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        
        majorSelectTextField.snp.makeConstraints {
            $0.top.equalTo(selectMajorLabel.snp.bottom).offset(16)
            $0.leading.equalTo(selectMajorLabel)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(48)
        }
        
        majorSelectBtn.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(majorSelectTextField)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(majorSelectTextField.snp.bottom).offset(24)
            $0.leading.equalTo(selectMajorLabel)
        }
        
        categoryCV.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(22)
            $0.leading.equalTo(categoryLabel)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(20)
        }
        
        questionDescLabel.snp.makeConstraints {
            $0.top.equalTo(categoryCV.snp.bottom).offset(7)
            $0.leading.equalTo(categoryLabel)
        }
        
        partitionBar.snp.makeConstraints {
            $0.top.equalTo(categoryCV.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        questionTitleTextField.snp.removeConstraints()
        questionTitleTextField.snp.makeConstraints {
            $0.top.equalTo(partitionBar.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        contentHeaderLabel.removeFromSuperview()
        
        questionWriteTextView.snp.removeConstraints()
        questionWriteTextView.snp.makeConstraints {
            $0.top.equalTo(textHighlightView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(questionTitleTextField)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-102)
        }
    }
    
    private func configureLabel() {
        [selectMajorLabel, categoryLabel].forEach {
            $0.textColor = .gray4
            $0.font = .PretendardSB(size: 14.0)
        }
    }
}

// MARK: - Bind Action & State
extension CommunityWriteVC {
    
    // MARK: Action
    private func bindAction(_ reactor: CommunityWriteReactor) {
        majorSelectBtn.rx.tap
            .subscribe(onNext: {
                self.presentHalfModalView()
            })
            .disposed(by: disposeBag)
        
        questionWriteNaviBar.rightActivateBtn.rx.tap
            .subscribe(onNext: {
                self.nadoAlert?.showNadoAlert(vc: self, message: self.confirmAlertMsg, confirmBtnTitle: "네", cancelBtnTitle: "아니요")
            })
            .disposed(by: disposeBag)
        
        nadoAlert?.confirmBtn.rx.tap.map{
            if self.isEditState {
                return CommunityWriteReactor.Action.tapQuestionEditBtn(postID: self.postID ?? 0, title: self.questionTitleTextField.text ?? "", content: self.questionWriteTextView.text ??
                "")
            } else {
                return CommunityWriteReactor.Action.tapQuestionWriteBtn(type: self.selectedCategory, majorID: self.majorID ?? MajorIDConstants.regardlessMajorID, answererID: 0, title: self.questionTitleTextField.text ?? "", content: self.questionWriteTextView.text)
            }
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        questionWriteNaviBar.dismissBtn.rx.tap
            .subscribe(onNext: {
                self.nadoAlert?.showNadoAlert(vc: self, message: self.dismissAlertMsg, confirmBtnTitle: "계속 작성", cancelBtnTitle: "나갈래요")
            })
            .disposed(by: disposeBag)
        
        nadoAlert?.cancelBtn.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: State
    private func bindState(_ reactor: CommunityWriteReactor) {
        reactor.state
            .map { $0.categoryData }
            .distinctUntilChanged()
            .map { $0 }
            .bind(to: categoryCV.rx.items) { [weak self] collectionView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityWriteCategoryCVC.className, for: indexPath)
                
                guard let categoryCell = cell as? CommunityWriteCategoryCVC else { return UICollectionViewCell() }
                categoryCell.setData(categoryText: item)
                
                // 수정 상태이고, 선택된 카테고리 인덱스일 때
                if self?.isEditState ?? false && index == self?.categoryIndex {
                    // 선택된 카테고리 인덱스의 라디오버튼 이미지를 darkColor로 설정한다.
                    categoryCell.setSelectedRadioBtnImage(isEdit: true)
                }
                
                return categoryCell
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map{ $0.writePostSuccess }
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.dismiss(animated: true, completion: {
                        self?.sendPostTypeDelegate?.sendPostType(postType: self?.selectedCategory ?? .community)
                    })
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Methods
extension CommunityWriteVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        categoryCV.register(CommunityWriteCategoryCVC.self, forCellWithReuseIdentifier: CommunityWriteCategoryCVC.className)
    }
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        categoryCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        questionWriteTextView.delegate = self
    }
    
    /// 초기 Action 설정 메서드
    private func setUpInitAction() {
        reactor?.action.onNext(.loadCategoryData)
        categoryCV.selectItem(at: [0, 0], animated: false, scrollPosition: .top)
    }
    
    /// 컴포넌트의 초기 스타일을 구성하는 메서드
    private func setUpInitStyle() {
        if isEditState {
            self.makeScreenAnalyticsEvent(screenName: "Community Tab", screenClass: "CommunityWriteVC+Edit")
            isTextViewEmpty = false
            questionWriteTextView.setDefaultStyle(isUsePlaceholder: false, placeholderText: "")
            questionTitleTextField.text = originTitle
            questionWriteTextView.text = originContent
            majorSelectTextField.setText(text: originMajor ?? "")
        } else {
            questionTitleTextField.placeholder = "제목을 입력하세요."
            questionWriteTextView.setDefaultStyle(isUsePlaceholder: true, placeholderText: "내용을 입력하세요.")
        }
        
        questionWriteNaviBar.configureTitleLabel(title: "게시글 작성")
    }
    
    /// 수정상태인지 아닌지에 따라 Alert Message를 지정하는 메서드
    private func setUpAlertMsgByEditState() {
        confirmAlertMsg =
        """
        글을 올리시겠습니까?
        """
        dismissAlertMsg = isEditState ?
        """
        페이지를 나가면
        수정한 내용이 저장되지 않아요.
        """
        :
        """
        페이지를 나가면
        작성중인 글이 삭제돼요.
        """
    }
    
    /// 수정상태인지 아닌지에 따라 CategoryCV의 수정 상태를 설정하는 메서드
    private func setUpCategoryCVByEditState() {
        if isEditState {
            categoryCV.selectItem(at: IndexPath(row: categoryIndex ?? 0, section: 0), animated: false, scrollPosition: .bottom)
            categoryCV.isUserInteractionEnabled = false
        }
    }
    
    // HalfModalView를 present하는 메서드
    private func presentHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.vcType = .search
        slideVC.cellType = .star
        slideVC.setUpTitleLabel("글을 올릴 학과를 선택해보세요.")
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.selectCommunityDelegate = self
        self.present(slideVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommunityWriteVC: UICollectionViewDelegateFlowLayout {
    
    /// sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 61.adjusted, height: 32.adjustedH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            selectedCategory = .general
            questionDescLabel.isHidden = true
        case 1:
            selectedCategory = .questionToEveryone
            questionDescLabel.isHidden = false
        default:
            selectedCategory = .information
            questionDescLabel.isHidden = true
        }
    }
}

// MARK: - UITextFieldDelegate
extension CommunityWriteVC: UITextViewDelegate {
    
    /// scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async() {
            scrollView.scrollIndicators.vertical?.backgroundColor = .scrollMint
        }
    }
    
    /// textViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray2 {
            textView.text = nil
            textView.textColor = .mainText
        }
    }
    
    /// textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        isTextViewEmpty = false
        scollByTextViewState(textView: textView)
    }
    
    /// textViewDidEndEditing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요."
            textView.textColor = .gray2
            isTextViewEmpty = true
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CommunityWriteVC: UIViewControllerTransitioningDelegate {
    
    /// presentationController - forPresented
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - SendCommunityInfoDelegate
extension CommunityWriteVC: SendCommunityInfoDelegate {
    func sendCommunityInfo(majorID: Int, majorName: String) {
        self.majorSelectTextField.text = majorName
        self.majorID = majorID
    }
}

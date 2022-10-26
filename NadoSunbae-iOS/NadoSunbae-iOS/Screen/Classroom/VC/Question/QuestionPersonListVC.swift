//
//  QuestionPersonListVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit
import SnapKit
import Then

class QuestionPersonListVC: BaseVC {
    
    // MARK: Properties
    private let questionPersonNaviBar = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backDefault)
    }
    
    private let questionPersonCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        $0.collectionViewLayout = layout
        $0.backgroundColor = .paleGray
        $0.showsVerticalScrollIndicator = false
    }
    
    var majorID: Int = MajorInfo.shared.selectedMajorID ?? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID)
    var majorUserList = MajorUserListDataModel()
    var isBlocked: Bool = false
    private var switchIsOn: Bool = false
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpDelegate()
        registerCell()
        registerXib()
        setUpTapNaviBackBtn()
        setUpMajorLabel()
        getMajorUserList(isExclude: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isBlocked {
            getMajorUserList(isExclude: false)
        }
    }
}

// MARK: - UI
extension QuestionPersonListVC {
    
    /// UI 구성 메서드
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubviews([questionPersonNaviBar, questionPersonCV])
        
        questionPersonNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        questionPersonCV.snp.makeConstraints {
            $0.top.equalTo(questionPersonNaviBar.snp.bottom)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
    }
}

// MARK: - Custom Methods
extension QuestionPersonListVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        questionPersonCV.delegate = self
        questionPersonCV.dataSource = self
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        questionPersonCV.register(QuestionPersonCVC.self, forCellWithReuseIdentifier: QuestionPersonCVC.className)
        questionPersonCV.register(QuestionPersonEmptyLabelCVC.self, forCellWithReuseIdentifier: QuestionPersonEmptyLabelCVC.className)
    }
    
    /// xib 등록 메서드
    private func registerXib() {
        let nibName = UINib(nibName: "QuestionPeopleHeaderView", bundle: nil)
        questionPersonCV.register(nibName, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "QuestionPeopleHeaderView")
    }
    
    /// 네비 back 버튼을 눌렀을 때 액션 set 메서드
    private func setUpTapNaviBackBtn() {
        questionPersonNaviBar.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 전공 Label text를 set하는 메서드
    private func setUpMajorLabel() {
        questionPersonNaviBar.configureTitleLabel(title: ((MajorInfo.shared.selectedMajorName != nil) ? MajorInfo.shared.selectedMajorName : UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)) ?? "")
    }
}

// MARK: - UICollectionViewDataSource
extension QuestionPersonListVC: UICollectionViewDataSource {
    
    /// numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /// numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return majorUserList.onQuestionUserList.isEmpty ? 1 : majorUserList.onQuestionUserList.count
        case 1:
            return majorUserList.offQuestionUserList.isEmpty ? 1 : majorUserList.offQuestionUserList.count
        default:
            return 0
        }
    }
    
    /// cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let questionPeopleCell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionPersonCVC.className, for: indexPath) as? QuestionPersonCVC,
              let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionPersonEmptyLabelCVC.className, for: indexPath) as? QuestionPersonEmptyLabelCVC else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            if majorUserList.onQuestionUserList.isEmpty {
                return emptyCell
            } else {
                questionPeopleCell.setData(model: majorUserList.onQuestionUserList[indexPath.row])
                return questionPeopleCell
            }
        case 1:
            if majorUserList.offQuestionUserList.isEmpty {
                return emptyCell
            } else {
                questionPeopleCell.setData(model: majorUserList.offQuestionUserList[indexPath.row])
                return questionPeopleCell
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    /// viewForSupplementaryElementOfKind
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "QuestionPeopleHeaderView", for: indexPath) as? QuestionPeopleHeaderView else { return UICollectionReusableView() }
            switch indexPath.section {
            case 0:
                headerView.headerTitleLabel.text = "질문 가능해요"
                headerView.configureUI(isQuestion: true)
                headerView.reviewFilterSwitch.setUpNadoSwitchState(isOn: switchIsOn)
                headerView.reviewFilterSwitch.switchDelegate = self
                return headerView
            case 1:
                headerView.headerTitleLabel.text = "쉬고 있어요"
                headerView.configureUI(isQuestion: false)
                return headerView
            default: return UICollectionReusableView()
            }
        default: return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension QuestionPersonListVC: UICollectionViewDelegate {
    
    /// sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return majorUserList.onQuestionUserList.isEmpty ? CGSize(width: 130.0, height: 22.0) : CGSize(width: 88.0, height: 120.0)
        case 1:
            return majorUserList.offQuestionUserList.isEmpty ? CGSize(width: 130.0, height: 22.0) : CGSize(width: 88.0, height: 120.0)
        default:
            return CGSize.zero
        }
    }
    
    /// didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetUserID = indexPath.section == 0 ? self.majorUserList.onQuestionUserList[indexPath.row].userID : self.majorUserList.offQuestionUserList[indexPath.row].userID
     
        if targetUserID == UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID) {
           goToRootOfTab(index: 4)
        } else {
            self.navigator?.instantiateVC(destinationViewControllerType: MypageUserVC.self, useStoryboard: true, storyboardName: MypageUserVC.className, naviType: .push) { mypageUserVC in
                mypageUserVC.targetUserID = targetUserID
                mypageUserVC.judgeBlockStatusDelegate = self
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension QuestionPersonListVC: UICollectionViewDelegateFlowLayout {
    
    /// insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 24, bottom: 40, right: 24)
    }
    
    /// referenceSizeForHeaderInSection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 35
        return CGSize(width: width, height: height)
    }
}

// MARK: - SendUpdateStatusDelegate
extension QuestionPersonListVC: SendBlockedInfoDelegate {
    func sendBlockedInfo(status: Bool, userID: Int) {
        self.isBlocked = status
    }
}

// MARK: - Network
extension QuestionPersonListVC {
    
    /// 특정 학과 User List 조회를 요청하는 API
    private func getMajorUserList(isExclude: Bool) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.getMajorUserListAPI(majorID: majorID, isExclude: isExclude, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                self.activityIndicator.stopAnimating()
                if let data = res as? MajorUserListDataModel {
                    self.majorUserList = data
                    self.questionPersonCV.reloadData()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMajorUserList(isExclude: isExclude)
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        })
    }
}

// MARK: - SwitchButtonDelegate
extension QuestionPersonListVC: SwitchButtonDelegate {
    func isOnValueChange(isOn: Bool) {
        switchIsOn = isOn
        getMajorUserList(isExclude: isOn)
    }
}

//
//  EditProfileVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/24.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefaultWithNadoBtn)
            navView.configureTitleLabel(title: "프로필 수정")
            navView.rightActivateBtn.setTitleWithStyle(title: "저장", size: 14, weight: .semiBold)
            navView.backBtn.press {
                guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
                
                alert.cancelBtn.press {
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.confirmBtn.press {
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.showNadoAlert(vc: self, message: "페이지를 나가면\n수정한 내용이 저장되지 않아요.", confirmBtnTitle: "계속 수정", cancelBtnTitle: "나갈래요")
            }
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileImgChangBtn: UIButton!
    @IBOutlet weak var nickNameChangeBtn: UIButton! {
        didSet {
            nickNameChangeBtn.isEnabled = false
            nickNameChangeBtn.setTitleColor(.mainDefault, for: .normal)
            nickNameChangeBtn.setTitleColor(.gray2, for: .disabled)
        }
    }
    @IBOutlet weak var nickNameRuleLabel: UILabel!
    @IBOutlet weak var nickNameTextField: NadoTextField!
    @IBOutlet weak var nickNameInfoLabel: UILabel!
    @IBOutlet weak var isOnQuestionToggleBtn: UIButton! {
        didSet {
            isOnQuestionToggleBtn.setImage(UIImage(named: "toggle_off"), for: .normal)
            isOnQuestionToggleBtn.setImage(UIImage(named: "toggle_on"), for: .selected)
            isOnQuestionToggleBtn.press {
                self.isOnQuestionToggleBtn.isSelected.toggle()
                self.changedInfo.isOnQuestion = self.isOnQuestionToggleBtn.isSelected
                self.setProfileData()
            }
        }
    }
    @IBOutlet weak var introTextView: NadoTextView!
    @IBOutlet weak var introTextCountLabel: UILabel!
    @IBOutlet weak var firstMajorTextField: NadoTextField!
    @IBOutlet weak var firstMajorStartTextField: NadoTextField!
    @IBOutlet weak var secondMajorTextField: NadoTextField!
    @IBOutlet weak var secondMajorStartTextField: NadoTextField!
    @IBOutlet weak var secondMajorStartBtn: UIButton! {
        didSet {
            secondMajorStartBtn.setTitleColor(.mainDefault, for: .normal)
            secondMajorStartBtn.setTitleColor(.gray2, for: .disabled)
        }
    }
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    var userInfo = MypageEditProfileRequestBodyModel()
    var changedInfo = MypageEditProfileRequestBodyModel()
    var secondMajorList: [MajorInfoModel] = []
    var isPresentingHalfModal = true
    var selectedProfileImgID = 0
    
    /// 내가 선택을 위해 '진입하는' 버튼의 태그
    var enterBtnTag = 0
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewDelegate()
        checkNickNameIsValid()
        hideKeyboardWhenTappedAround()
        setSaveBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyInfo()
        makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: EditProfileVC.className)
    }
    
    // MARK: @IBAction
    @IBAction func tapNickNameChangeBtn(_ sender: Any) {
        requestCheckNickName(nickName: nickNameTextField.text!)
    }
    
    @IBAction func tapChangeProfileImgBtn(_ sender: UIButton) {
        presentChangeProfileImgVC()
    }
    
    @IBAction func tapSelectFirstMajorBtn(_ sender: UIButton) {
        showMajorSelectModal(enterType: .firstMajor)
    }
    
    @IBAction func tapSelectFirstMajorStartBtn(_ sender: UIButton) {
        showMajorSelectModal(enterType: .firstMajorStart)
    }
    
    @IBAction func tapSelectSecondMajorBtn(_ sender: UIButton) {
        showMajorSelectModal(enterType: .secondMajor)
    }
    
    @IBAction func tapSelectSecondMajorStartBtn(_ sender: UIButton) {
        showMajorSelectModal(enterType: .secondMajorStart)
    }
}
    
// MARK: - UI
extension EditProfileVC {
    private func configureUI() {
        profileImgView.image = UIImage(named: "grayProfileImage\(userInfo.profileImageID)")
        profileImgChangBtn.makeRounded(cornerRadius: 8)
        nickNameTextField.placeholder = userInfo.nickname
        isOnQuestionToggleBtn.isSelected = userInfo.isOnQuestion
        if userInfo.bio.isEmpty {
            introTextView.setDefaultStyle(isUsePlaceholder: true, placeholderText: "나를 한줄로 소개해보세요.")
        } else {
            introTextView.setDefaultStyle(isUsePlaceholder: false, placeholderText: "나를 한줄로 소개해보세요.")
            introTextView.text = userInfo.bio
        }
        firstMajorTextField.text = userInfo.firstMajorName
        firstMajorStartTextField.text = userInfo.firstMajorStart
        secondMajorTextField.text = userInfo.secondMajorName
        secondMajorStartTextField.text = userInfo.secondMajorStart
        checkSecondMajorStatus()
        
        introTextView.rx.text.orEmpty
            .skip(1)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                self.checkIntroText(input: $0)
                if self.introTextView.textColor != .gray2 {
                    self.introTextCountLabel.text = "\($0.count)/최대 40자"
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func changeLabelColor(isOK: Bool, label: UILabel) {
        label.textColor = isOK ? .gray3 : .red
    }
    
    private func checkSecondMajorStatus() {
        if secondMajorTextField.text == "미진입" {
            secondMajorStartBtn.setTitle("선택", for: .normal)
            secondMajorStartTextField.placeholder = "미진입"
            secondMajorStartTextField.text = ""
            secondMajorStartBtn.isEnabled = false
        } else {
            secondMajorStartBtn.isEnabled = true
            self.secondMajorStartTextField.placeholder = "선택하기"
        }
    }
    
    private func setNavViewNadoRightBtn(status: Bool) {
        self.navView.rightActivateBtn.isActivated = status
        self.navView.rightActivateBtn.isEnabled = status
    }
    
    private func setSaveBtn() {
        navView.rightActivateBtn.press {
            guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            
            alert.cancelBtn.press {
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.confirmBtn.press {
                self.setProfileData()
                self.requestEditProfile(data: self.changedInfo)
                self.judgeEditProfileGA()
            }
            
            alert.showNadoAlert(vc: self, message: "내 정보를 수정하시겠습니까?", confirmBtnTitle: "저장", cancelBtnTitle: "아니요")
        }
    }
}
    
// MARK: - Custom Methods
extension EditProfileVC {
    
    /// TextView delegate 설정
    private func setTextViewDelegate() {
        introTextView.delegate = self
    }
    
    /// 닉네임 유효성 검사
    private func checkNickNameIsValid() {
        nickNameTextField.rx.text
            .orEmpty
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                let regex = "[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9]{2,8}"
                if changedText.count == 0 {
                    DispatchQueue.main.async {
                        self.nickNameChangeBtn.setTitle("변경", for: .normal)
                    }
                    self.changeLabelColor(isOK: true, label: self.nickNameRuleLabel)
                    self.nickNameChangeBtn.isEnabled = false
                } else if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) {
                    DispatchQueue.main.async {
                        self.nickNameChangeBtn.setTitle("확인", for: .normal)
                    }
                    self.changeLabelColor(isOK: true, label: self.nickNameRuleLabel)
                    self.nickNameChangeBtn.isEnabled = true
                    self.nickNameInfoLabel.text = ""
                    self.setNavViewNadoRightBtn(status: false)
                } else {
                    DispatchQueue.main.async {
                        self.nickNameChangeBtn.setTitle("확인", for: .normal)
                    }
                    self.changeLabelColor(isOK: false, label: self.nickNameRuleLabel)
                    self.nickNameChangeBtn.isEnabled = false
                    self.nickNameInfoLabel.text = ""
                    self.setNavViewNadoRightBtn(status: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 한줄소개 글자수 제한 메서드
    private func checkIntroText(input: String) {
        if input.count >= 40 {
            let index = input.index(input.startIndex, offsetBy: 40)
            self.introTextView.text = String(input[..<index])
        }
    }
    
    /// 변경할 changedInfo 세팅
    private func setProfileData() {
        changedInfo.profileImageID = selectedProfileImgID
        if introTextView.textColor == .gray2 {
            changedInfo.bio = ""
        } else {
            changedInfo.bio = introTextView.text
        }
        changedInfo.nickname = nickNameTextField.isEmpty ? userInfo.nickname : nickNameTextField.text ?? ""
        changedInfo.isOnQuestion = isOnQuestionToggleBtn.isSelected
        judgeSaveBtnState()
    }
    
    private func judgeSaveBtnState() {
        
        /// 아래 세 경우, 저장 버튼 비활성화
        /// 1. 수정한 정보가 없거나
        /// 2. 제1전공, 제2전공 동일하게 선택했거나
        /// 3. 미진입이 아닌데 제2전공 진입시기를 선택하지 않은 경우
        if userInfo == changedInfo || !(checkMajorDuplicate(firstTextField: firstMajorTextField, secondTextField: secondMajorTextField)) || (secondMajorStartTextField.isEmpty && secondMajorStartTextField.placeholder == "선택하기") {
            setNavViewNadoRightBtn(status: false)
        } else {
            setNavViewNadoRightBtn(status: true)
        }
    }
    
    /// 제1, 제2전공 중복 선택 검사, 중복되지 않으면 true
    private func checkMajorDuplicate(firstTextField: UITextField, secondTextField: UITextField) -> Bool {
        return !(firstTextField.text == secondTextField.text)
    }
    
    /// 프로필 사진 변경 바텀시트를 present하는 메서드
    private func presentChangeProfileImgVC() {
        let slideVC = EditProfileImgModalVC()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.originProfileImgID = userInfo.profileImageID
        slideVC.changedProfileImgID = selectedProfileImgID
        slideVC.selectNewProfileDelegate = self
        self.isPresentingHalfModal = false
        self.present(slideVC, animated: true)
    }
    
    private func showMajorSelectModal(enterType: SignUpMajorInfoEnterType) {
        let slideVC = SignUpModalVC()
        slideVC.univID = UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID)
        slideVC.enterType = enterType
        
        switch enterType {
        case .firstMajor, .secondMajor:
            slideVC.vcType = .search
        case .firstMajorStart, .secondMajorStart:
            slideVC.vcType = .basic
        }
        slideVC.cellType = .basic
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.selectMajorDelegate = self
        
        self.present(slideVC, animated: true, completion: nil)
    }
    
    /// 서버에 요청해 받아 온 UserInfo를 EditProfile에 맞게 변환하여 리턴
    private func getEditProfileUserInfo(data: MypageUserInfoModel) -> MypageEditProfileRequestBodyModel{
        var editProfileUserInfo = MypageEditProfileRequestBodyModel()
        editProfileUserInfo.profileImageID = data.profileImageID
        editProfileUserInfo.bio = data.bio ?? ""
        editProfileUserInfo.nickname = data.nickname
        editProfileUserInfo.isOnQuestion = data.isOnQuestion
        editProfileUserInfo.firstMajorName = data.firstMajorName
        editProfileUserInfo.firstMajorID = UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID)
        editProfileUserInfo.firstMajorStart = data.firstMajorStart
        editProfileUserInfo.secondMajorName = data.secondMajorName
        editProfileUserInfo.secondMajorID = UserDefaults.standard.integer(forKey: UserDefaults.Keys.SecondMajorID)
        editProfileUserInfo.secondMajorStart = data.secondMajorStart
        return editProfileUserInfo
    }
    
    /// 프로필 수정 GA 이벤트 수집을 위한 메서드
    private func judgeEditProfileGA() {
        if self.userInfo.bio != self.changedInfo.bio {
            self.makeAnalyticsEvent(eventName: .profile_change, parameterValue: "oneline_introduce")
        }
        if self.userInfo.profileImageID != self.changedInfo.profileImageID {
            self.makeAnalyticsEvent(eventName: .profile_change, parameterValue: "profile_image")
        }
        if self.userInfo.isOnQuestion == false && self.changedInfo.isOnQuestion == true {
            self.makeAnalyticsEvent(eventName: .profile_change, parameterValue: "question_allow_on")
        }
        if self.userInfo.isOnQuestion == true && self.changedInfo.isOnQuestion == false {
            self.makeAnalyticsEvent(eventName: .profile_change, parameterValue: "question_allow_off")
        }
    }
}

// MARK: - UITextViewDelegate
extension EditProfileVC: UITextViewDelegate {
    
    /// textViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray2 {
            textView.text = nil
            textView.textColor = .mainText
        }
        navView.rightActivateBtn.isUserInteractionEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .gray2
            textView.text = "나를 한줄로 소개해보세요."
        }
        navView.rightActivateBtn.isUserInteractionEnabled = true
        setProfileData()
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension EditProfileVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let halfModalVC = HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
        halfModalVC.modalHeight = isPresentingHalfModal ? 632 : 449
        
        return halfModalVC
    }
}

// MARK: - SendUpdateModalDelegate
extension EditProfileVC: SendUpdateModalDelegate {
    func sendUpdate(data: Any) {
        if let selectedImgID = data as? Int {
            self.profileImgView.image = UIImage(named: "grayProfileImage\(selectedImgID)")
            selectedProfileImgID = selectedImgID
        }
        
        if let majorInfoTuple = data as? (Any, SignUpMajorInfoEnterType) {
            switch majorInfoTuple.1 {
            case .firstMajor:
                if let majorInfoData = majorInfoTuple.0 as? MajorInfoModel {
                    self.firstMajorTextField.text = majorInfoData.majorName
                    self.changedInfo.firstMajorID = majorInfoData.majorID
                    self.changedInfo.firstMajorName = majorInfoData.majorName
                }
            case .firstMajorStart:
                if let majorInfoData = majorInfoTuple.0 as? String {
                    self.firstMajorStartTextField.text = majorInfoData
                    self.changedInfo.firstMajorStart = majorInfoData
                }
            case .secondMajor:
                if let majorInfoData = majorInfoTuple.0 as? MajorInfoModel {
                    self.secondMajorTextField.text = majorInfoData.majorName
                    self.changedInfo.secondMajorID = majorInfoData.majorID
                    self.changedInfo.secondMajorName = majorInfoData.majorName
                    if majorInfoData.majorName == "미진입" {
                        self.changedInfo.secondMajorStart = "미진입"
                    }
                    checkSecondMajorStatus()
                }
                
            case .secondMajorStart:
                if let majorInfoData = majorInfoTuple.0 as? String {
                    self.secondMajorStartTextField.text = majorInfoData
                    self.secondMajorStartBtn.setTitle("변경", for: .normal)
                    self.changedInfo.secondMajorStart = majorInfoData
                }
            }
        }
        self.setProfileData()
    }
}


// MARK: - Network
extension EditProfileVC {
    private func getMyInfo() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getUserInfo(userID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID), completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageUserInfoModel {
                    self.userInfo = self.getEditProfileUserInfo(data: data)
                    self.changedInfo = self.getEditProfileUserInfo(data: data)
                    self.selectedProfileImgID = data.profileImageID
                    self.configureUI()
                }
                self.activityIndicator.stopAnimating()
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMyInfo()
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        })
    }
    
    private func requestCheckNickName(nickName: String) {
        view.endEditing(true)
        if nickName == userInfo.nickname {
            self.nickNameInfoLabel.textColor = .mainDark
            self.nickNameTextField.text = nickName
            self.nickNameInfoLabel.text = "사용 가능한 닉네임입니다."
            self.setProfileData()
        } else {
            self.activityIndicator.startAnimating()
            SignAPI.shared.checkNickNameDuplicate(nickName: nickName) { networkResult in
                switch networkResult {
                case .success:
                    self.activityIndicator.stopAnimating()
                    self.nickNameInfoLabel.textColor = .mainDark
                    self.nickNameInfoLabel.text = "사용 가능한 닉네임입니다."
                    self.changedInfo.nickname = nickName
                    self.nickNameTextField.text = nickName
                    self.setProfileData()
                case .requestErr(let success):
                    self.activityIndicator.stopAnimating()
                    if success is Bool {
                        self.nickNameInfoLabel.textColor = .red
                        self.nickNameInfoLabel.text = "이미 사용중인 닉네임입니다."
                        self.setProfileData()
                    }
                default:
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                }
            }
        }
    }
    
    private func requestEditProfile(data: MypageEditProfileRequestBodyModel) {
        self.activityIndicator.startAnimating()
        MypageSettingAPI.shared.editProfile(data: data, completion: { networkResult in
            switch networkResult {
            case .success:
                self.activityIndicator.stopAnimating()
                UserDefaults.standard.set(data.firstMajorID, forKey: UserDefaults.Keys.FirstMajorID)
                UserDefaults.standard.set(self.firstMajorTextField.text, forKey: UserDefaults.Keys.FirstMajorName)
                UserDefaults.standard.set(data.secondMajorID, forKey: UserDefaults.Keys.SecondMajorID)
                UserDefaults.standard.set(self.secondMajorTextField.text, forKey: UserDefaults.Keys.SecondMajorName)
                self.navigationController?.popViewController(animated: true)
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.requestEditProfile(data: data)
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        })
    }
}

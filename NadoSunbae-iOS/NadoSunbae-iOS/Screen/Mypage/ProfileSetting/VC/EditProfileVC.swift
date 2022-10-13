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
            navView.rightActivateBtn.setTitleWithStyle(title: "저장", size: 14)
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
                self.judgeSaveBtnState()
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
    var userInfo = MypageUserInfoModel()
    var changedInfo = MypageUserInfoModel()
    var profileData = EditProfileRequestModel()
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
        requestSecondMajorList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), filterType: "secondMajor")
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
        presentHalfModalView(title: "본전공", hasNoMajorOption: false)
        
        // TODO: SignUpModalVC로 변경
        //        guard let slideVC = UIStoryboard.init(name: SelectMajorModalVC.className, bundle: nil).instantiateViewController(withIdentifier: SelectMajorModalVC.className) as? SelectMajorModalVC else { return }
        //
        //        /// 제2전공 진입시기 선택 버튼을 탭했는데, 제2전공이 선택되어있지 않을 경우
        //        if !(sender.tag == 3 && secondMajorTextField.text == "미진입") {
        //            slideVC.enterdBtnTag = sender.tag
        //            self.enterBtnTag = sender.tag
        //
        //            slideVC.modalPresentationStyle = .custom
        //            slideVC.transitioningDelegate = self
        //            slideVC.selectMajorDelegate = self
        //
        //            self.present(slideVC, animated: true, completion: nil)
        //        }
    }
    
    @IBAction func tapSelectFirstMajorStartBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func tapSelectSecondMajorBtn(_ sender: UIButton) {
        presentHalfModalView(title: "제2전공", hasNoMajorOption: true, isSecondMajorSheet: true)
    }
    
    @IBAction func tapSelectSecondMajorStartBtn(_ sender: UIButton) {
        
    }
}
    
    // MARK: - UI
extension EditProfileVC {
    private func configureUI() {
        profileImgView.image = UIImage(named: "profileImage\(userInfo.profileImageID)")
        profileImgChangBtn.makeRounded(cornerRadius: 8)
        nickNameTextField.placeholder = userInfo.nickname
        isOnQuestionToggleBtn.isSelected = userInfo.isOnQuestion
        introTextView.setDefaultStyle(isUsePlaceholder: true, placeholderText: "나를 한줄로 소개해보세요.")
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
            secondMajorStartTextField.text = ""
            secondMajorStartBtn.isEnabled = false
        } else {
            secondMajorStartBtn.isEnabled = true
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
                self.requestEditProfile(data: self.profileData)
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
    
    /// 변경할 profileData 세팅
    private func setProfileData() {
        // TODO: 기존엔 MypageUserInfoModel을 사용하였으나, 서버 모델 변경 이후 MypageUserInfoModel을 사용하여 put request를 보낼 수 없게 됨. 이 뷰 담당자가 새로 모델 만들어야 함!
        //        profileData.nickName = changedInfo.nickname
        //        profileData.firstMajorID = changedInfo.firstMajorID
        //        profileData.secondMajorID = changedInfo.secondMajorID
        //        profileData.firstMajorStart = changedInfo.firstMajorStart
        //        profileData.secondMajorStart = changedInfo.secondMajorID == 1 ? "미진입" : changedInfo.secondMajorStart
        //        profileData.isOnQuestion = changedInfo.isOnQuestion
    }
    
    private func judgeSaveBtnState() {
        //        if (userInfo.secondMajorID != changedInfo.secondMajorID && changedInfo.secondMajorID != 1 && changedInfo.secondMajorStart == "미진입") || !(checkMajorDuplicate(firstTextField: firstMajorTextField, secondTextField: secondMajorTextField)) {
        //            setNavViewNadoRightBtn(status: false)
        //        } else {
        //            setNavViewNadoRightBtn(status: userInfo == changedInfo ? false : true)
        //        }
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
    
    /// HalfModalView를 present하는 메서드
    private func presentHalfModalView(title: String, hasNoMajorOption: Bool, isSecondMajorSheet: Bool = false) {
        let slideVC = HalfModalVC()
        slideVC.vcType = .search
        slideVC.cellType = .star
        slideVC.setUpTitleLabel(title)
        slideVC.hasNoMajorOption = hasNoMajorOption
        slideVC.isSecondMajorSheet = isSecondMajorSheet
        slideVC.secondMajorList = self.secondMajorList
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.selectMajorDelegate = self
        self.isPresentingHalfModal = true
        self.present(slideVC, animated: true)
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
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .gray2
            textView.text = "나를 한줄로 소개해보세요."
        }
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
        if let selectedImg = data as? UIImage {
            self.profileImgView.image = selectedImg
            
            switch selectedImg {
            case UIImage(named: "profileImage1"):
                selectedProfileImgID = 1
            case UIImage(named: "profileImage2"):
                selectedProfileImgID = 2
            case UIImage(named: "profileImage3"):
                selectedProfileImgID = 3
            case UIImage(named: "profileImage4"):
                selectedProfileImgID = 4
            case UIImage(named: "profileImage5"):
                selectedProfileImgID = 5
            default:
                break
            }
        }
            
        switch enterBtnTag {
        case 0:
            if let majorInfoData = data as? MajorInfoModel {
                self.firstMajorTextField.text = majorInfoData.majorName
                //                self.changedInfo.firstMajorID = majorInfoData.majorID
            }
        case 1:
            self.firstMajorStartTextField.text = data as? String
            self.changedInfo.firstMajorStart = data as? String ?? ""
        case 2:
            if let majorInfoData = data as? MajorInfoModel {
                self.secondMajorTextField.text = majorInfoData.majorName
                //                self.changedInfo.secondMajorID = majorInfoData.majorID
                //                if changedInfo.secondMajorID == 1 {
                //                    changedInfo.secondMajorStart = "미진입"
                //                }
                checkSecondMajorStatus()
            }
        case 3:
            self.secondMajorStartTextField.text = data as? String
            self.secondMajorStartBtn.setTitle("변경", for: .normal)
            self.changedInfo.secondMajorStart = data as? String ?? ""
        default:
#if DEVELOPMENT
            print("SignUpMajorInfoVC SendUpdateDelegate error")
#endif
        }
        self.judgeSaveBtnState()
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
                    self.userInfo = data
                    self.changedInfo = data
                    self.selectedProfileImgID = data.profileImageID
                    self.configureUI()
                }
                self.activityIndicator.stopAnimating()
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
    
    private func requestCheckNickName(nickName: String) {
        view.endEditing(true)
        if nickName == userInfo.nickname {
            self.nickNameInfoLabel.textColor = .mainDark
            self.nickNameTextField.text = nickName
            self.nickNameInfoLabel.text = "사용 가능한 닉네임입니다."
            self.judgeSaveBtnState()
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
                    self.judgeSaveBtnState()
                case .requestErr(let success):
                    self.activityIndicator.stopAnimating()
                    if success is Bool {
                        self.nickNameInfoLabel.textColor = .red
                        self.nickNameInfoLabel.text = "이미 사용중인 닉네임입니다."
                        self.judgeSaveBtnState()
                    }
                default:
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            }
        }
    }
    
    /// 제2전공 학과 리스트 조회 메서드
    private func requestSecondMajorList(univID: Int, filterType: String) {
        PublicAPI.shared.getMajorListAPI(univID: univID, filterType: filterType) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if let data = res as? [MajorInfoModel] {
                    self.secondMajorList = data
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    private func requestEditProfile(data: EditProfileRequestModel) {
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
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.requestEditProfile(data: self.profileData)
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}

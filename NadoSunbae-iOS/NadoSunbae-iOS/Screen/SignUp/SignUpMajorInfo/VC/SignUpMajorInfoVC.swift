//
//  SignUpMajorInfoVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/09.
//

import UIKit
import RxSwift
import RxCocoa

enum SignUpMajorInfoEnterType: String {
    case firstMajor = "본전공"
    case firstMajorStart = "본전공 진입시기"
    case secondMajor = "제2전공"
    case secondMajorStart = "제2전공 진입시기"
}

class SignUpMajorInfoVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var univTextField: NadoTextField!
    @IBOutlet weak var firstMajorTextField: NadoTextField!
    @IBOutlet weak var firstMajorStartTextField: NadoTextField!
    @IBOutlet weak var secondMajorTextField: NadoTextField!
    @IBOutlet weak var secondMajorStartTextField: NadoTextField!
    @IBOutlet weak var nextBtn: NadoSunbaeBtn! {
        didSet {
            nextBtn.isActivated = false
            nextBtn.isEnabled = false
        }
    }
    @IBOutlet weak var prevBtn: NadoSunbaeBtn!
    @IBOutlet weak var univSelectBtn: UIButton!
    @IBOutlet weak var firstMajorSelectBtn: UIButton!
    @IBOutlet weak var firstMajorStartSelectBtn: UIButton!
    @IBOutlet weak var secondMajorSelectBtn: UIButton!
    @IBOutlet weak var secondMajorStartSelectBtn: UIButton! {
        didSet {
            secondMajorStartSelectBtn.setTitleColor(.gray2, for: .disabled)
        }
    }
    
    // MARK: Properties
    var univList = ["고려대학교", "서울여자대학교", "중앙대학교"]
    var signUpData = SignUpBodyModel()
    let disposeBag = DisposeBag()
    
    /// 내가 선택을 위해 '진입하는' 버튼의 태그
    var enterBtnTag = 0
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkUnivSelected()
        checkSelectBtnStatus()
    }
    
    // MARK: IBAction
    @IBAction func tapUnivBtn(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var univAlertActionList = [UIAlertAction]()
        
        for univName in univList {
            univAlertActionList.append(alertAction(title: univName, targetTextField: univTextField))
        }
        
        let readyAction = UIAlertAction(title: "타 대학은 현재 준비중입니다", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        readyAction.setValue(UIColor.gray3, forKey: "titleTextColor")

        (univAlertActionList + [readyAction, cancelAction]).forEach { action in
            optionMenu.addAction(action)
        }
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func tapFirstMajorSelectBtn(_ sender: Any) {
        showMajorSelectModal(enterType: .firstMajor)
    }
    
    @IBAction func tapFirstMajorStartBtn(_ sender: Any) {
        showMajorSelectModal(enterType: .firstMajorStart)
    }
    
    @IBAction func tapSecondMajorSelectBtn(_ sender: Any) {
        showMajorSelectModal(enterType: .secondMajor)
    }
    
    @IBAction func tapSecondMajorStartBtn(_ sender: Any) {
        showMajorSelectModal(enterType: .secondMajorStart)
    }
    
    private func showMajorSelectModal(enterType: SignUpMajorInfoEnterType) {
        
        /// 제2전공 진입시기 선택 버튼을 탭했는데, 제2전공이 선택되어있지 않을 경우 선택버튼 비활성화
        if !(enterType == .secondMajorStart && secondMajorTextField.text == "미진입") {
            if let selectedUnivID = self.univList.firstIndex(of: univTextField.text ?? "") {
                let slideVC = SignUpModalVC()
                slideVC.univID = selectedUnivID + 1
                slideVC.setTitleLabel(title: enterType.rawValue)
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
        }
    }
    
    @IBAction func tapPrevBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNextBtn(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: SignUpUserInfoVC.className, bundle: nil).instantiateViewController(withIdentifier: SignUpUserInfoVC.className) as? SignUpUserInfoVC else { return }
        if signUpData.secondMajorStart == "선택하기" {
            signUpData.secondMajorStart = "미진입"
        }
        vc.signUpData = signUpData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapDismissBtn(_ sender: UIButton) {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        alert.cancelBtn.press {
            self.dismiss(animated: true, completion: nil)
        }
        alert.showNadoAlert(vc: self, message: """
페이지를 나가면
회원가입이 취소돼요.
"""
                            , confirmBtnTitle: "계속 작성", cancelBtnTitle: "나갈래요")
    }
}

// MARK: - UI
extension SignUpMajorInfoVC {
    private func configureUI() {
        [univTextField, firstMajorTextField, firstMajorStartTextField, secondMajorTextField, secondMajorStartTextField].forEach { textField in
            textField?.placeholder = "선택하기"
            textField?.isUserInteractionEnabled = false
        }
        prevBtn.setBackgroundColor(.mainLight, for: .normal)
    }
}

// MARK: - Custom Methods
extension SignUpMajorInfoVC {
    private func alertAction(title: String, targetTextField: UITextField) -> UIAlertAction {
        let alertAction = UIAlertAction(title: title, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if title != targetTextField.text {
                targetTextField.text = title
                if let selectedUnivID = self.univList.firstIndex(of: self.univTextField.text ?? "") {
                    self.signUpData.universityID = selectedUnivID + 1
                    self.checkNextBtnIsEnabled()
                }
            }
        })
        return alertAction
    }
    
    /// textField에 값이 들어올 때마다 NextBtn 활성화할지를 체크하는 함수
    private func checkNextBtnIsEnabled() {
        secondMajorStartSelectBtn.isEnabled = !(secondMajorTextField.text == "미진입")
        if !(univTextField.isEmpty) && !(firstMajorTextField.isEmpty) && !(firstMajorStartTextField.isEmpty) && !(secondMajorTextField.isEmpty) && checkMajorDuplicate(firstTextField: firstMajorTextField, secondTextField: secondMajorTextField) {
            if secondMajorTextField.text == "미진입" {
                nextBtn.isActivated = true
                nextBtn.isEnabled = true
            } else {
                nextBtn.isActivated = !(secondMajorStartTextField.isEmpty)
                nextBtn.isActivated = !(secondMajorStartTextField.isEmpty)
            }
        } else {
            nextBtn.isActivated = false
            nextBtn.isEnabled = false
        }
    }
    
    /// 제1, 제2전공 중복 선택 검사, 중복되지 않으면 true
    private func checkMajorDuplicate(firstTextField: UITextField, secondTextField: UITextField) -> Bool {
        return !(firstTextField.text == secondTextField.text)
    }
    
    /// textField에 값이 있으면 '선택' 버튼을 '변경' 버튼으로 바꾸는 함수
    private func checkSelectBtnStatus() {
        [(univSelectBtn, univTextField),(firstMajorSelectBtn, firstMajorTextField),
         (firstMajorStartSelectBtn, firstMajorStartTextField),
         (secondMajorSelectBtn, secondMajorTextField),
         (secondMajorStartSelectBtn, secondMajorStartTextField)].forEach { (btn, textField) in
            textField?.rx.observe(String.self, "text")
                .subscribe(onNext: { changedText in
                    btn?.setTitle(changedText?.isEmpty ?? false ? "선택" : "변경", for: .normal)
                }).disposed(by: disposeBag)
        }
    }
    
    /// 학교 선택 여부에 따라 제1/제2전공 textField, button 상태를 업데이트하는 함수
    private func checkUnivSelected() {
        univTextField.rx.observe(String.self, "text")
            .subscribe(onNext: { univText in
                [self.firstMajorTextField, self.firstMajorStartTextField, self.secondMajorTextField, self.secondMajorStartTextField].forEach { textField in
                        textField?.text = ""
                }
                [self.firstMajorSelectBtn, self.firstMajorStartSelectBtn, self.secondMajorSelectBtn, self.secondMajorStartSelectBtn].forEach { button in
                        button?.isEnabled = univText == "" ? false : true
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension SignUpMajorInfoVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - SendUpdateModalDelegate
extension SignUpMajorInfoVC: SendUpdateModalDelegate {
    func sendUpdate(data: Any) {
        
        if let majorInfoTuple = data as? (Any, SignUpMajorInfoEnterType) {
            switch majorInfoTuple.1 {
            case .firstMajor:
                if let majorInfoData = majorInfoTuple.0 as? MajorInfoModel {
                    self.firstMajorTextField.text = majorInfoData.majorName
                    self.signUpData.firstMajorID = majorInfoData.majorID
                }
            case .firstMajorStart:
                if let majorInfoData = majorInfoTuple.0 as? String {
                    self.firstMajorStartTextField.text = majorInfoData
                    self.signUpData.firstMajorStart = majorInfoData
                }
            case .secondMajor:
                if let majorInfoData = majorInfoTuple.0 as? MajorInfoModel {
                    self.secondMajorTextField.text = majorInfoData.majorName
                    self.signUpData.secondMajorID = majorInfoData.majorID
                    if majorInfoData.majorName == "미진입" {
                        self.signUpData.secondMajorStart = "미진입"
                        self.secondMajorStartTextField.text = ""
                    }
                }
                
            case .secondMajorStart:
                if let majorInfoData = majorInfoTuple.0 as? String {
                    self.secondMajorStartTextField.text = majorInfoData
                    self.signUpData.secondMajorStart = majorInfoData
                }
            }
        }
        checkNextBtnIsEnabled()
    }
}

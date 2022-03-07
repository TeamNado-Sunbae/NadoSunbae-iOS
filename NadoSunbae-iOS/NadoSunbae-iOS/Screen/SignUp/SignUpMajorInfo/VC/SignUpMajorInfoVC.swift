//
//  SignUpMajorInfoVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/09.
//

import UIKit

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
    @IBOutlet weak var secondMajorStartSelectBtn: UIButton!
    
    // MARK: Properties
    var univList = ["고려대학교"]
    var signUpData = SignUpBodyModel()
    
    /// 내가 선택을 위해 '진입하는' 버튼의 태그
    var enterBtnTag = 0
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
    
    @IBAction func tapSelectMajorORStartBtn(_ sender: UIButton) {
        guard let slideVC = UIStoryboard.init(name: SelectMajorModalVC.className, bundle: nil).instantiateViewController(withIdentifier: SelectMajorModalVC.className) as? SelectMajorModalVC else { return }
        
        /// 제2전공 진입시기 선택 버튼을 탭했는데, 제2전공이 선택되어있지 않을 경우
        if sender.tag == 3 && secondMajorTextField.isEmpty {
            // TODO: 처리 어떻게 하지...? 일단 modal 안 뜨게 막아둠
        } else {
            slideVC.enterdBtnTag = sender.tag
            self.enterBtnTag = sender.tag
            
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            slideVC.selectMajorDelegate = self
            
            self.present(slideVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapPrevBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNextBtn(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: SignUpUserInfoVC.className, bundle: nil).instantiateViewController(withIdentifier: SignUpUserInfoVC.className) as? SignUpUserInfoVC else { return }
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
            targetTextField.text = title
            self.checkSelectBtnStatus(btn: self.univSelectBtn, textField: self.univTextField)
            self.signUpData.universityID = 1
        })
        return alertAction
    }
    
    /// textField에 값이 들어올 때마다 NextBtn 활성화할지를 체크하는 함수
    private func checkNextBtnIsEnabled() {
        if !(univTextField.isEmpty) && !(firstMajorTextField.isEmpty) && !(firstMajorStartTextField.isEmpty) {
            if secondMajorTextField.isEmpty {
                secondMajorStartSelectBtn.isEnabled = true
                nextBtn.isActivated = false
                nextBtn.isEnabled = false
            } else {
                secondMajorStartSelectBtn.isEnabled = !(secondMajorTextField.text == "미진입")
                nextBtn.isActivated = !(secondMajorStartTextField.isEmpty) || secondMajorTextField.text == "미진입"
                nextBtn.isEnabled = !(secondMajorStartTextField.isEmpty) || secondMajorTextField.text == "미진입"
            }
        } else {
            secondMajorStartSelectBtn.isEnabled = true
            nextBtn.isActivated = false
            nextBtn.isEnabled = false
        }
    }
    
    /// textField에 값이 있으면 '선택' 버튼을 '변경' 버튼으로 바꾸는 함수
    private func checkSelectBtnStatus(btn: UIButton, textField: UITextField) {
        btn.setTitle(textField.isEmpty ? "선택" : "변경", for: .normal)
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
        switch enterBtnTag {
        case 0:
            if let majorInfoData = data as? MajorInfoModel {
                self.firstMajorTextField.text = majorInfoData.majorName
                self.signUpData.firstMajorID = majorInfoData.majorID
            }
        case 1:
            self.firstMajorStartTextField.text = data as? String
            self.signUpData.firstMajorStart = data as? String ?? ""
        case 2:
            if let majorInfoData = data as? MajorInfoModel {
                self.secondMajorTextField.text = majorInfoData.majorName
                self.signUpData.secondMajorID = majorInfoData.majorID
                if majorInfoData.majorName == "미진입" {
                    self.signUpData.secondMajorStart = "미진입"
                    self.secondMajorStartTextField.text = ""
                }
            }
        case 3:
            self.secondMajorStartTextField.text = data as? String
            self.signUpData.secondMajorStart = data as? String ?? ""
        default:
            #if DEBUG
            print("SignUpMajorInfoVC SendUpdateDelegate error")
            #endif
        }
        checkNextBtnIsEnabled()
        [(firstMajorSelectBtn, firstMajorTextField),
         (firstMajorStartSelectBtn, firstMajorStartTextField),
         (secondMajorSelectBtn, secondMajorTextField),
         (secondMajorStartSelectBtn, secondMajorStartTextField)].forEach { (btn, textField) in
            checkSelectBtnStatus(btn: btn, textField: textField)
        }
    }
}

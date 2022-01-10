//
//  SignUpMajorInfoVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/09.
//

import UIKit

class SignUpMajorInfoVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var univTextField: NadoTextField!
    @IBOutlet weak var firstMajorTextField: NadoTextField!
    @IBOutlet weak var firstMajorStartTextField: NadoTextField!
    @IBOutlet weak var secondMajorTextField: NadoTextField!
    @IBOutlet weak var secondMajorStartTextField: NadoTextField!
    @IBOutlet weak var nextBtn: NadoSunbaeBtn!
    
    var univList = ["고려대학교"]
    /// 내가 선택을 위해 '진입하는' 버튼의 태그
    var enterBtnTag = 0
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Custom Method
    private func configureUI() {
        [univTextField, firstMajorTextField, firstMajorStartTextField, secondMajorTextField, secondMajorStartTextField].forEach { textField in
            textField?.placeholder = "선택하기"
            textField?.isUserInteractionEnabled = false
        }
    }
    
    private func alertAction(title: String, targetTextField: UITextField) -> UIAlertAction {
        let alertAction = UIAlertAction(title: title, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            targetTextField.text = title
        })
        return alertAction
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
    
    @IBAction func tapFirstMajorBtn(_ sender: UIButton) {
        guard let slideVC = UIStoryboard.init(name: SelectMajorModalVC.className, bundle: nil).instantiateViewController(withIdentifier: SelectMajorModalVC.className) as? SelectMajorModalVC else { return }
        slideVC.enterdBtnTag = sender.tag
        self.enterBtnTag = sender.tag
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.selectMajorDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @IBAction func tapPrevBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNextBtn(_ sender: UIButton) {
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}

extension SignUpMajorInfoVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension SignUpMajorInfoVC: SendUpdateDelegate {
    func sendUpdate(data: Any) {
        switch enterBtnTag {
        case 0:
            self.firstMajorTextField.text = data as? String
        case 1:
            self.firstMajorStartTextField.text = data as? String
        case 2:
            self.secondMajorTextField.text = data as? String
        case 3:
            self.secondMajorStartTextField.text = data as? String
        default:
            #if DEBUG
            print("SignUpMajorInfoVC SendUpdateDelegate error")
            #endif
        }
    }
}

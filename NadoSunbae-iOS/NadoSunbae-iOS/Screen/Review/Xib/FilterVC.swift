//
//  FilterVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/02/04.
//

import UIKit

class FilterVC: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var completeBtn: NadoSunbaeBtn!
    @IBOutlet weak var resetBtn: UIButton! {
        didSet {
            resetBtn.press {
                [self.majorBtn, self.secondMajorBtn, self.learnInfoBtn, self.recommendClassBtn, self.badClassBtn, self.futureJobBtn, self.tipBtn].forEach {
                    btn in btn?.isSelected = false
                }
                [self.majorBtn, self.secondMajorBtn, self.learnInfoBtn, self.recommendClassBtn, self.badClassBtn, self.futureJobBtn, self.tipBtn].forEach {
                    btn in self.setBtnStatus(btn: btn)
                }
            }
        }
    }
    @IBOutlet weak var majorBtn: UIButton!
    @IBOutlet weak var secondMajorBtn: UIButton!
    @IBOutlet weak var learnInfoBtn: UIButton!
    @IBOutlet weak var recommendClassBtn: UIButton!
    @IBOutlet weak var badClassBtn: UIButton!
    @IBOutlet weak var futureJobBtn: UIButton!
    @IBOutlet weak var tipBtn: UIButton!
    
    // MARK: Properties
    var selectFilterDelegate: SendUpdateStatusDelegate?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaultUI()
        tapCompleteBtnAction()
    }
    
    // MARK: IBAction
    @IBAction func tapDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapMajorBtn(_ sender: UIButton) {
        majorBtn.isSelected.toggle()
        setBtnStatus(btn: majorBtn)
    }
    
    @IBAction func tapSecondMajorBtn(_ sender: UIButton) {
        secondMajorBtn.isSelected.toggle()
        setBtnStatus(btn: secondMajorBtn)
    }
    
    @IBAction func tapLearnInfoBtn(_ sender: UIButton) {
        learnInfoBtn.isSelected.toggle()
        setBtnStatus(btn: learnInfoBtn)
    }
    
    @IBAction func tapRecommendClassBtn(_ sender: UIButton) {
        recommendClassBtn.isSelected.toggle()
        setBtnStatus(btn: recommendClassBtn)
    }
    
    @IBAction func tapBadClassBtn(_ sender: UIButton) {
        badClassBtn.isSelected.toggle()
        setBtnStatus(btn: badClassBtn)
    }
    
    @IBAction func tapFutureJobBtn(_ sender: UIButton) {
        futureJobBtn.isSelected.toggle()
        setBtnStatus(btn: futureJobBtn)
    }
    
    @IBAction func tapTipBtn(_ sender: UIButton) {
        tipBtn.isSelected.toggle()
        setBtnStatus(btn: tipBtn)
    }
}

// MARK: - UI
extension FilterVC {
    private func configureDefaultUI() {
        [majorBtn, secondMajorBtn, learnInfoBtn, badClassBtn, recommendClassBtn, futureJobBtn, tipBtn].forEach {
            btn in btn?.makeRounded(cornerRadius: 12)
        }
        resetBtn.makeRounded(cornerRadius: 14.adjusted)
        
        completeBtn.isActivated = true
        completeBtn.setTitle("적용하기", for: .normal)
        
        /// 필터 버튼이 이전 적용 상태값으로 보이도록
        let btnStatus = FilterInfo.shared.selectedBtnList
        
        majorBtn.isSelected = btnStatus[0]
        secondMajorBtn.isSelected = btnStatus[1]
        learnInfoBtn.isSelected = btnStatus[2]
        recommendClassBtn.isSelected = btnStatus[3]
        badClassBtn.isSelected = btnStatus[4]
        futureJobBtn.isSelected = btnStatus[5]
        tipBtn.isSelected = btnStatus[6]
        [majorBtn, secondMajorBtn, learnInfoBtn, recommendClassBtn, badClassBtn, futureJobBtn, tipBtn].forEach {
            btn in self.setBtnStatus(btn: btn)
        }
    }
    
    /// 버튼 UI 설정해주는 함수
    private func configureBtnUI(btn: UIButton, btnBgColor: UIColor, titleFont: UIFont, btnTitleColor: UIColor) {
        btn.backgroundColor = btnBgColor
        btn.titleLabel?.font = titleFont
        btn.setTitleColor(btnTitleColor, for: .normal)
    }
    
    /// 버튼 상태에 따른 UI 설정 함수
    private func setBtnStatus(btn: UIButton) {
        if btn.isSelected {
            configureBtnUI(btn: btn, btnBgColor: .mainLight, titleFont: .PretendardSB(size: 14), btnTitleColor: .mainDefault)
        } else {
            configureBtnUI(btn: btn, btnBgColor: .gray0, titleFont: .PretendardR(size: 14), btnTitleColor: .gray3)
        }
    }
    
    /// 버튼 상태 싱글톤에 저장
    private func saveBtnStatus() {
        FilterInfo.shared.selectedBtnList[0] = majorBtn.isSelected
        FilterInfo.shared.selectedBtnList[1] = secondMajorBtn.isSelected
        FilterInfo.shared.selectedBtnList[2] = learnInfoBtn.isSelected
        FilterInfo.shared.selectedBtnList[3] = recommendClassBtn.isSelected
        FilterInfo.shared.selectedBtnList[4] = badClassBtn.isSelected
        FilterInfo.shared.selectedBtnList[5] = futureJobBtn.isSelected
        FilterInfo.shared.selectedBtnList[6] = tipBtn.isSelected
    }
}

// MARK: - Private Methods
extension FilterVC {
    private func tapCompleteBtnAction() {
        completeBtn.press {
            var filterStatus = false
            if self.majorBtn.isSelected || self.secondMajorBtn.isSelected || self.learnInfoBtn.isSelected || self.recommendClassBtn.isSelected || self.badClassBtn.isSelected || self.futureJobBtn.isSelected || self.tipBtn.isSelected {
                filterStatus = true
            }
            if let selectFilterDelegate = self.selectFilterDelegate {
                self.saveBtnStatus()
                selectFilterDelegate.sendStatus(data: filterStatus)
            }
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
            })
        }
    }
}

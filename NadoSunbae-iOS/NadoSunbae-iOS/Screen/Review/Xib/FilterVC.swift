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
                self.isSelectedMajorBtn = false
                self.isSelectedSecondMajorBtn = false
                self.isSelectedLearnInfoBtn = false
                self.isSelectedLearnInfoBtn = false
                self.isSelectedBadClassBtn = false
                self.isSelectedRecommendClassBtn = false
                self.isSelectedFutureJobBtn = false
                self.isSelectedTipBtn = false
                self.configureBtnUI()
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
    var isSelectedMajorBtn = false
    var isSelectedSecondMajorBtn = false
    var isSelectedLearnInfoBtn = false
    var isSelectedBadClassBtn = false
    var isSelectedRecommendClassBtn = false
    var isSelectedFutureJobBtn = false
    var isSelectedTipBtn = false
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
        isSelectedMajorBtn.toggle()
        configureBtnUI()
    }
    
    @IBAction func tapSecondMajorBtn(_ sender: UIButton) {
        isSelectedSecondMajorBtn.toggle()
        configureBtnUI()
    }
    
    @IBAction func tapLearnInfoBtn(_ sender: UIButton) {
        isSelectedLearnInfoBtn.toggle()
        configureBtnUI()
    }
    
    @IBAction func tapRecommendClassBtn(_ sender: UIButton) {
        isSelectedRecommendClassBtn.toggle()
        configureBtnUI()
    }
    
    @IBAction func tapBadClassBtn(_ sender: UIButton) {
        isSelectedBadClassBtn.toggle()
        configureBtnUI()
    }
    
    @IBAction func tapFutureJobBtn(_ sender: UIButton) {
        isSelectedFutureJobBtn.toggle()
        configureBtnUI()
    }
    
    @IBAction func tapTipBtn(_ sender: UIButton) {
        isSelectedTipBtn.toggle()
        configureBtnUI()
    }
}

// MARK: - UI
extension FilterVC {
    private func configureDefaultUI() {
        completeBtn.isActivated = false
        completeBtn.setTitle("적용하기", for: .normal)
        
        majorBtn.makeRounded(cornerRadius: 12)
        secondMajorBtn.makeRounded(cornerRadius: 12)
        learnInfoBtn.makeRounded(cornerRadius: 12)
        badClassBtn.makeRounded(cornerRadius: 12)
        recommendClassBtn.makeRounded(cornerRadius: 12)
        futureJobBtn.makeRounded(cornerRadius: 12)
        tipBtn.makeRounded(cornerRadius: 12)
        resetBtn.makeRounded(cornerRadius: 14.adjusted)
    }
    
    private func configureBtnUI() {
        if isSelectedMajorBtn == true {
            majorBtn.backgroundColor = .mainLight
            majorBtn.titleLabel?.font = .PretendardSB(size: 14)
            majorBtn.setTitleColor(UIColor.mainDefault, for: .normal)
        } else if isSelectedMajorBtn == false {
            majorBtn.backgroundColor = .gray0
            majorBtn.titleLabel?.font = .PretendardR(size: 14)
            majorBtn.setTitleColor(UIColor.gray3, for: .normal)
        }
        if isSelectedSecondMajorBtn == true {
            secondMajorBtn.backgroundColor = .mainLight
            secondMajorBtn.titleLabel?.font = .PretendardSB(size: 14)
            secondMajorBtn.setTitleColor(UIColor.mainDefault, for: .normal)
        } else if isSelectedSecondMajorBtn == false {
            secondMajorBtn.backgroundColor = .gray0
            secondMajorBtn.titleLabel?.font = .PretendardR(size: 14)
            secondMajorBtn.setTitleColor(UIColor.gray3, for: .normal)
        }
        if isSelectedLearnInfoBtn == true {
            learnInfoBtn.backgroundColor = .mainLight
            learnInfoBtn.titleLabel?.font = .PretendardSB(size: 14)
            learnInfoBtn.setTitleColor(UIColor.mainDefault, for: .normal)
        } else if isSelectedLearnInfoBtn == false {
            learnInfoBtn.backgroundColor = .gray0
            learnInfoBtn.titleLabel?.font = .PretendardR(size: 14)
            learnInfoBtn.setTitleColor(UIColor.gray3, for: .normal)
        }
        if isSelectedRecommendClassBtn == true {
            recommendClassBtn.backgroundColor = .mainLight
            recommendClassBtn.titleLabel?.font = .PretendardSB(size: 14)
            recommendClassBtn.setTitleColor(UIColor.mainDefault, for: .normal)
        } else if isSelectedRecommendClassBtn == false {
            recommendClassBtn.backgroundColor = .gray0
            recommendClassBtn.titleLabel?.font = .PretendardR(size: 14)
            recommendClassBtn.setTitleColor(UIColor.gray3, for: .normal)
        }
        if isSelectedBadClassBtn == true {
            badClassBtn.backgroundColor = .mainLight
            badClassBtn.titleLabel?.font = .PretendardSB(size: 14)
            badClassBtn.setTitleColor(UIColor.mainDefault, for: .normal)
        } else if isSelectedBadClassBtn == false {
            badClassBtn.backgroundColor = .gray0
            badClassBtn.titleLabel?.font = .PretendardR(size: 14)
            badClassBtn.setTitleColor(UIColor.gray3, for: .normal)
        }
        if isSelectedFutureJobBtn == true {
            futureJobBtn.backgroundColor = .mainLight
            futureJobBtn.titleLabel?.font = .PretendardSB(size: 14)
            futureJobBtn.setTitleColor(UIColor.mainDefault, for: .normal)
        } else if isSelectedFutureJobBtn == false {
            futureJobBtn.backgroundColor = .gray0
            futureJobBtn.titleLabel?.font = .PretendardR(size: 14)
            futureJobBtn.setTitleColor(UIColor.gray3, for: .normal)
        }
        if isSelectedTipBtn == true {
            tipBtn.backgroundColor = .mainLight
            tipBtn.titleLabel?.font = .PretendardSB(size: 14)
            tipBtn.setTitleColor(UIColor.mainDefault, for: .normal)
        } else if isSelectedTipBtn == false {
            tipBtn.backgroundColor = .gray0
            tipBtn.titleLabel?.font = .PretendardR(size: 14)
            tipBtn.setTitleColor(UIColor.gray3, for: .normal)
        }
        
        if isSelectedMajorBtn || isSelectedSecondMajorBtn || isSelectedLearnInfoBtn || isSelectedRecommendClassBtn || isSelectedBadClassBtn || isSelectedFutureJobBtn || isSelectedTipBtn == true {
            completeBtn.isActivated = true
        } else {
            completeBtn.isActivated = false
        }
    }
}

// MARK: - Private Methods
extension FilterVC {
    private func tapCompleteBtnAction() {
        completeBtn.press {
            let filterStatus = true
            if let selectFilterDelegate = self.selectFilterDelegate {
                selectFilterDelegate.sendStatus(data: filterStatus)
            }
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
            })
        }
    }
}

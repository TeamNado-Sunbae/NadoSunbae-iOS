//
//  MypageInfoListVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/15.
//

import UIKit

class MypageInfoListVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var infoSegmentView: NadoSegmentView! {
        didSet {
            infoSegmentView.questionBtn.isActivated = false
            infoSegmentView.questionBtn.isEnabled = true
            infoSegmentView.infoBtn.isActivated = true
            infoSegmentView.infoBtn.isEnabled = false
            infoSegmentView.backgroundColor = .bgGray
        }
    }

    // MARK: Properties
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTapQuestionBtn()
    }
}

// MARK: Custom Methods
extension MypageInfoListVC {
    func setUpTapQuestionBtn() {
        infoSegmentView.questionBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 0)
            }
        }
    }
}

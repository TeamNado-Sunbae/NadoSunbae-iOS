//
//  MypageQuestionListVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/15.
//

import UIKit

class MypageQuestionListVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var questionSegmentView: NadoSegmentView! {
        didSet {
            questionSegmentView.backgroundColor = .bgGray
        }
    }
    
    // MARK: Properties
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTapInfoBtn()
    }
}

// MARK: Custom Methods
extension MypageQuestionListVC {
    func setUpTapInfoBtn() {
        questionSegmentView.infoBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 1)
            }
        }
    }
}



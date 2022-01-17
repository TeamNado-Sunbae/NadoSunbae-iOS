//
//  InfoMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then

class InfoMainVC: UIViewController {
    
    // MARK: Properties
    let infoSegmentView = NadoSegmentView().then {
        $0.questionBtn.isActivated = false
        $0.infoBtn.isActivated = true
    }
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTapQuestionBtn()
    }
}

// MARK: - UI
extension InfoMainVC {
    func configureUI() {
        self.view.addSubviews([infoSegmentView])
        
        infoSegmentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38)
        }
    }
}

// MARK: Custom Methods
extension InfoMainVC {
    func setUpTapQuestionBtn() {
        infoSegmentView.questionBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 0)
            }
        }
    }
}


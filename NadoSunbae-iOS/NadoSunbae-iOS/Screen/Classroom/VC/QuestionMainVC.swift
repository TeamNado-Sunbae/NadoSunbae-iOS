//
//  QuestionMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then

class QuestionMainVC: UIViewController {

    // MARK: Properties
    let questionSegmentView = NadoSegmentView()
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTapInfoBtn()
    }
}

// MARK: - UI
extension QuestionMainVC {
    func configureUI() {
        self.view.addSubviews([questionSegmentView])
        
        questionSegmentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38)
        }
    }
}

// MARK: - Custom Methods
extension QuestionMainVC {
    func setUpTapInfoBtn() {
        questionSegmentView.infoBtn.press {
            
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 1)
            }
        }
    }
}


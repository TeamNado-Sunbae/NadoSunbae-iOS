//
//  QuestionPeopleHeaderView.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import UIKit

class QuestionPeopleHeaderView: UICollectionReusableView {
    
    @IBOutlet var headerTitleLabel: UILabel! {
        didSet {
            headerTitleLabel.textColor = .black
            headerTitleLabel.font = .PretendardM(size: 16.0)
        }
    }
    
    @IBOutlet weak var headerSubLabel: UILabel!
    @IBOutlet weak var reviewFilterSwitch: NadoSwitch!
}

// MARK: - UI
extension QuestionPeopleHeaderView {
    
    /// 질문 가능상태 여부에 따라 UI를 결정짓는 메서드
    func configureUI(isQuestion: Bool) {
        headerSubLabel.isHidden = isQuestion ? false : true
        reviewFilterSwitch.isHidden = isQuestion ? false : true
    
    }
}

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
}

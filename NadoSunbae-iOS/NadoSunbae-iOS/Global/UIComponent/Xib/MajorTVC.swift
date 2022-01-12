//
//  MajorTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit

class MajorTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet weak var starBnt: UIButton!
    @IBOutlet weak var majorNameLabel: UILabel!
    
    // MARK: Life Cycle Part
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Private Methods
    /// Label에 학과 이름 setting하는 함수
    func setData(reviewData: ReviewData) {
        majorNameLabel.text = reviewData.majorName
    }
}


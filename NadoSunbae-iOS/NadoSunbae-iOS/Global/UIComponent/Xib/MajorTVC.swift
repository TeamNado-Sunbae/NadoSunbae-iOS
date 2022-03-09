//
//  MajorTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit

class MajorTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet weak var checkImgView: UIImageView!
    @IBOutlet weak var majorNameLabel: UILabel!
    
    // MARK: Life Cycle Part
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkImgView.isHidden = selected ? false : true
        if selected {
            majorNameLabel.setLabel(text: majorNameLabel.text ?? "", color: .mainDefault, size: 14, weight: .semiBold)
        } else {
            majorNameLabel.setLabel(text: majorNameLabel.text ?? "", color: .mainText, size: 14, weight: .regular)
        }
    }
}

// MARK: - Private Methods
extension MajorTVC {
    
    /// Label에 학과 이름 setting하는 함수
    func setData(majorName: String) {
        majorNameLabel.text = majorName
    }
}


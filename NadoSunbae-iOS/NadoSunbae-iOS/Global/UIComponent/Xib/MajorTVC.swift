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
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var majorNameLabel: UILabel!
    
    // MARK: Properties
    var isStarBtnSelected = false {
        didSet {
            setStarImg()
        }
    }
    
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
    
    // MARK: IBAction
    @IBAction func tapStarBtn(_ sender: Any) {
        isStarBtnSelected = !isStarBtnSelected
    }
}

// MARK: - Private Methods
extension MajorTVC {
    
    /// Label에 학과 이름 setting하는 함수
    func setData(reviewData: ReviewData) {
        majorNameLabel.text = reviewData.majorName
    }
    
    /// 즐겨찾기 버튼 이미지 설정
    func setStarImg() {
        if isStarBtnSelected {
            starBtn.setImage(UIImage.init(named: "star_selected"), for: .normal)
        } else {
            starBtn.setImage(UIImage.init(named: "star"), for: .normal)
        }
    }
}


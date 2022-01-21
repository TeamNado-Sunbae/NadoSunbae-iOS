//
//  ReviewMainImgTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/10.
//

import UIKit

class ReviewMainImgTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var reviewMainImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .PretendardB(size: 21.adjusted)
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.font = .PretendardM(size: 11.adjusted)
        }
    }
    
    // MARK: Life Cycle Part
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Custom Methods
extension ReviewMainImgTVC {
    
    /// 이미지 세팅 함수
    func setData(ImgData: ReviewImgData) {
        reviewMainImgView.image = ImgData.makeImg()
    }
}

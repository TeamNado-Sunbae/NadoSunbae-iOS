//
//  ReviewDetailGrayTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/03/09.
//

import UIKit

class ReviewDetailGrayTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var questionStatusLabel: UILabel!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Custom Methods
extension ReviewDetailGrayTVC {
    func setData(postData: ReviewPostDetailData) {
        questionStatusLabel.isHidden = postData.writer.isOnQuestion ? false : true
    }
}

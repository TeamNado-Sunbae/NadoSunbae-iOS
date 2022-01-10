//
//  ReviewMainImgTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/10.
//

import UIKit

class ReviewMainImgTVC: UITableViewCell, UITableViewRegisterable {
    
    /// Register할 Nib get
    static var isFromNib: Bool {
        get {
            return true
        }
    }

    @IBOutlet weak var reviewMainImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(ImgData: ReviewImgData) {
        reviewMainImgView.image = ImgData.makeImg()
    }
}

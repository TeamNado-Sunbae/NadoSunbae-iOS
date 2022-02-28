//
//  BlockListTVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class BlockListTVC: BaseTVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var undoBlockBtn: UIButton!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Custom Methods
    func setData(data: GetBlockListResponseModel) {
        profileImgView.image = UIImage(named: "profileImage\(data.profileImageID)")
        nickNameLabel.text = data.nickname
    }
}

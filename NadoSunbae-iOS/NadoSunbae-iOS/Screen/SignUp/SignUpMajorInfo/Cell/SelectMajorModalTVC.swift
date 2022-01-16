//
//  SelectMajorModalTVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/10.
//

import UIKit

class SelectMajorModalTVC: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var selectImgView: UIImageView!
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectImgView.isHidden = selected ? false : true
        if selected {
            majorLabel.setLabel(text: majorLabel.text ?? "", color: .mainDefault, size: 14, weight: .semiBold)
        } else {
            majorLabel.setLabel(text: majorLabel.text ?? "", color: .mainText, size: 14, weight: .regular)
        }
    }
    
    // MARK: Custom Method
    func setData(majorName: String) {
        majorLabel.text = majorName
    }
}

//
//  NotificationSettingBasicTVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class NotificationSettingBasicTVC: BaseTVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isOnToggleBtn: UIButton! {
        didSet {
            isOnToggleBtn.setImage(UIImage(named: "toggle_off"), for: .normal)
            isOnToggleBtn.setImage(UIImage(named: "toggle_on"), for: .selected)
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Custom Methods
    func setData(title: String, isOn: Bool) {
        titleLabel.text = title
        isOnToggleBtn.isSelected = isOn
    }
}

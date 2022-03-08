//
//  SettingVersionTVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class SettingVersionTVC: BaseTVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Custom Methods
    func setData(title: String, version: String) {
        titleLabel.text = title
        versionLabel.text = "현재 \(AppVersion.shared.currentVersion) / 최신 \(AppVersion.shared.latestVersion)"
    }
}

//
//  NotificationTVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/17.
//

import UIKit

class NotificationTVC: BaseTVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var redCircleImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setContentViewInset()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Custom Methods
    private func configureUI() {
        contentView.makeRounded(cornerRadius: 8.adjusted)
        self.backgroundColor = .clear
    }
    
    private func setContentViewInset() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}

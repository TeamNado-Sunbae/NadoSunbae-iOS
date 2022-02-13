//
//  InfoQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/13.
//

import UIKit

class InfoQuestionTVC: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var majorInfoLabel: UILabel!
    @IBOutlet weak var questionContentTextView: UITextView!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var infoLikeBtn: UIButton!
    @IBOutlet weak var infoLikeImgView: UIImageView!
    @IBOutlet weak var infoLikeCountLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            infoLikeBtn.backgroundColor = isSelected ? UIColor.nadoBlack : UIColor.gray0
            infoLikeImgView.image = isSelected ? UIImage(named: "heart_mint") : UIImage(named: "heart")
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: IBAction
    @IBAction func tapInfoLikeBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

// MARK: - UI
extension InfoQuestionTVC {
    private func configureUI() {
        infoLikeBtn.layer.cornerRadius = 16
    }
}

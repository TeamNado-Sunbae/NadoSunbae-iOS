//
//  InfoQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/13.
//

import UIKit

class InfoQuestionTVC: UITableViewCell {

    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var majorInfoLabel: UILabel!
    @IBOutlet weak var questionContentTextView: UITextView!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  MypageQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/15.
//

import UIKit

class MypageQuestionTVC: BaseTVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Custom Methods
    func setData(data: MypageQuestionModel) {
        titleLabel.text = data.title
        contentLabel.text = data.content
        nickNameLabel.text = data.nickName
        timeLabel.text = data.writeTime
        commentCountLabel.text = "\(data.commentCount)"
        likeCountLabel.text = "\(data.likeCount)"
    }
}

//
//  InfoQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/13.
//

import UIKit

class InfoQuestionTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet var infoTitleLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorInfoLabel: UILabel!
    @IBOutlet var questionContentTextView: UITextView! {
        didSet {
            questionContentTextView.isScrollEnabled = false
        }
    }
    @IBOutlet var postDateLabel: UILabel!
    @IBOutlet var infoLikeBackView: UIView!
    @IBOutlet var infoLikeBtn: UIButton!
    @IBOutlet var infoLikeImgView: UIImageView!
    @IBOutlet var infoLikeCountLabel: UILabel!
    
    // MARK: Propertie
    var tapLikeBtnAction : (() -> ())?
    
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
        infoLikeBackView.backgroundColor = sender.isSelected ? UIColor.nadoBlack : UIColor.gray0
        infoLikeImgView.image = sender.isSelected ? UIImage(named: "heart_mint") : UIImage(named: "heart")
        tapLikeBtnAction?()
    }
}

// MARK: - UI
extension InfoQuestionTVC {
    private func configureUI() {
        infoLikeBackView.layer.cornerRadius = 16
    }
}

// MARK: - Custom Methods
extension InfoQuestionTVC {
    
    /// 데이터 바인딩하는 메서드
    func bindData(_ model: ClassroomMessageList) {
        infoTitleLabel.text = model.title
        nicknameLabel.text = model.writer.nickname
        majorInfoLabel.text = convertToMajorInfoString(model.writer.firstMajorName, model.writer.firstMajorStart, model.writer.secondMajorName, model.writer.secondMajorStart)
        questionContentTextView.text = model.content
        postDateLabel.text = model.createdAt.serverTimeToString(forUse: .forDefault)
    }
    
    func bindLikeData(_ model: Like) {
        infoLikeImgView.image = model.isLiked ? UIImage(named: "heart_mint") : UIImage(named: "heart")
        infoLikeCountLabel.text = "\(model.likeCount)"
    }
}


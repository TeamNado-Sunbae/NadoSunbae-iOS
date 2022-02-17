//
//  BaseQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import UIKit

class BaseQuestionTVC: BaseTVC {
    
    // MARK: Properties
    let questionTitleLabel = UILabel().then {
        $0.textColor = .nadoBlack
        $0.font = .PretendardSB(size: 14.0)
        $0.sizeToFit()
    }
    
    let questionContentLabel = UILabel().then {
        $0.textColor = .gray3
        $0.font = .PretendardR(size: 14.0)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let nicknameLabel = UILabel().then {
        $0.textColor = .gray4
        $0.font = .PretendardSB(size: 14.0)
        $0.sizeToFit()
    }
    
    private let questionTimeLabel = UILabel().then {
        $0.textColor = .gray2
        $0.font = .PretendardR(size: 12.0)
        $0.sizeToFit()
    }
    
    private let commentImgView = UIImageView().then {
        $0.image = UIImage(named: "icComment")
        $0.contentMode = .scaleAspectFill
    }
    
    private let commentCountLabel = UILabel().then {
        $0.textColor = .gray2
        $0.font = .PretendardL(size: 12.0)
        $0.sizeToFit()
    }
    
    private let likeImgView = UIImageView().then {
        $0.image = UIImage(named: "heart")
        $0.contentMode = .scaleAspectFill
    }
    
    private let likeCountLabel = UILabel().then {
        $0.textColor = .gray2
        $0.font = .PretendardL(size: 12.0)
        $0.sizeToFit()
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI
extension BaseQuestionTVC {
    
    @objc
    func configureUI() {
        contentView.addSubviews([questionTitleLabel, questionContentLabel, nicknameLabel, questionTimeLabel, commentImgView, commentCountLabel, likeImgView, likeCountLabel])
        
        questionTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        questionContentLabel.snp.makeConstraints {
            $0.top.equalTo(questionTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.lessThanOrEqualTo(44)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(questionContentLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-18)
        }
        
        questionTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(questionTitleLabel.snp.trailing)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        likeImgView.snp.makeConstraints {
            $0.trailing.equalTo(likeCountLabel.snp.leading).offset(-8)
            $0.width.equalTo(16)
            $0.height.equalTo(12)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(likeImgView.snp.leading).offset(-16)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        commentImgView.snp.makeConstraints {
            $0.trailing.equalTo(commentCountLabel.snp.leading)
            $0.height.width.equalTo(32)
            $0.centerY.equalTo(nicknameLabel)
        }
    }
}

// MARK: - Custom Methods
extension BaseQuestionTVC {
    func setData(data: ClassroomPostList) {
        questionTitleLabel.text = data.title
        questionContentLabel.text = data.content
        nicknameLabel.text = data.writer.nickname
        questionTimeLabel.text = data.createdAt.serverTimeToString(forUse: .forDefault)
        commentCountLabel.text = "\(data.commentCount)"
        likeCountLabel.text = "\(data.like.likeCount)"
    }
}


//
//  QuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit
import SnapKit
import Then

class QuestionTVC: BaseTVC {
    
    // MARK: Properties
    private let questionTitleLabel = UILabel().then {
        $0.textColor = .nadoBlack
        $0.font = .PretendardSB(size: 14.0)
        $0.sizeToFit()
    }
    
    private let questionContentLabel = UILabel().then {
        $0.textColor = .gray3
        $0.font = .PretendardR(size: 14.0)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    private let nicknameLabel = UILabel().then {
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
        $0.image = UIImage(named: "btnDiamond")
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 16, bottom: 11, right: 16))
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
extension QuestionTVC {
    private func configureUI() {
        contentView.addSubviews([questionTitleLabel, questionContentLabel, nicknameLabel, questionTimeLabel, commentImgView, commentCountLabel, likeImgView, likeCountLabel])
        
        questionTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-4)
        }
        
        questionContentLabel.snp.makeConstraints {
            $0.top.equalTo(questionTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-4)
            $0.height.lessThanOrEqualTo(44)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(questionContentLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-7)
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
            $0.trailing.equalTo(likeCountLabel.snp.leading)
            $0.height.width.equalTo(32)
            $0.centerY.equalTo(nicknameLabel)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(likeImgView.snp.leading).offset(-8)
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
extension QuestionTVC {
    func setData(data: MypageQuestionModel) {
        questionTitleLabel.text = data.title
        questionContentLabel.text = data.content
        nicknameLabel.text = data.nickName
        questionTimeLabel.text = data.writeTime
        commentCountLabel.text = "\(data.commentCount)"
        likeCountLabel.text = "\(data.likeCount)"
    }
}

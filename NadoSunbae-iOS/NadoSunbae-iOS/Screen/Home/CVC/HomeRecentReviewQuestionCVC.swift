//
//  HomeRecentReviewQuestionCVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

final class HomeRecentReviewQuestionCVC: BaseCVC {
    
    // MARK: Components
    private let majorLabel = UILabel().then {
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .PretendardSB(size: 14)
        $0.textColor = .mainDefault
    }
    private let authorLabel = UILabel().then {
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .PretendardL(size: 12)
        $0.textColor = .gray3
    }
    private let dateLabel = UILabel().then {
        $0.font = .PretendardL(size: 12)
        $0.textColor = .gray2
    }
    private let contentLabel = UILabel().then {
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .PretendardSB(size: 16)
        $0.textColor = .mainText
        $0.numberOfLines = 0
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRecentReviewData(data: HomeRecentReviewResponseDataElement) {
        majorLabel.isHidden = false
        authorLabel.isHidden = true
        majorLabel.text = data.majorName
        contentLabel.text = data.oneLineReview
        dateLabel.text = data.createdAt.serverTimeToString(forUse: .forDefault)
    }
    
    func setRecentPersonalQuestionData(data: PostListResModel) {
        majorLabel.isHidden = true
        authorLabel.isHidden = false
        
        // TODO: 나중에 모델 확정되면 수정 필요
        authorLabel.text = data.majorName
        contentLabel.text = data.content
        dateLabel.text = data.createdAt.serverTimeToString(forUse: .forDefault)
    }
}

// MARK: - UI
extension HomeRecentReviewQuestionCVC {
    private func configureUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray0.cgColor
        contentView.makeRounded(cornerRadius: 8)
        
        contentView.addSubviews([majorLabel, authorLabel, dateLabel, contentLabel])
        
        majorLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(17)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(17)
        }
        
        dateLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(majorLabel.snp.bottom).offset(8)
            $0.left.right.equalTo(majorLabel)
            $0.bottom.lessThanOrEqualTo(dateLabel.snp.top).offset(-12)
        }
    }
}

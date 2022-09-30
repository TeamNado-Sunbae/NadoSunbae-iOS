//
//  InfoCommentHeaderTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/13.
//

import UIKit
import SnapKit
import Then
import RxSwift

class InfoCommentHeaderTVC: BaseTVC {
    
    // MARK: Properties
    private var commentCountLabel = UILabel().then {
        $0.font = .PretendardR(size: 12.0)
        $0.textColor = .gray2
    }

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI
extension InfoCommentHeaderTVC {
    
    /// UI 구성 메서드
    private func configureUI(isCommentZero: Bool) {
        self.backgroundColor = .paleGray
        self.addSubview(commentCountLabel)
        
        commentCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
            if isCommentZero {
                $0.bottom.equalToSuperview().offset(-8)
            } else {
                $0.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - Custom Methods
extension InfoCommentHeaderTVC {
    
    /// 데이터 바인딩하는 메서드
    func bindData(commentCount: Int) {
        commentCountLabel.text = "댓글 \(commentCount)개"
        commentCountLabel.sizeToFit()
        commentCount > 0 ? configureUI(isCommentZero: false) : configureUI(isCommentZero: true)
    }
}

//
//  ReviewDetailPostTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailPostTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: Custom Methods
    
    /// 리스트 데이터 세팅 함수
    func setData(postData: ReviewDetailData) {
        iconImgView.image = postData.makeImg()
        titleLabel.text = postData.title
        contentLabel.text = postData.content
    }
}

// MARK: - UI
extension ReviewDetailPostTVC {
    private func configureUI() {
        contentView.makeRounded(cornerRadius: 40.adjusted)
        contentView.backgroundColor = .white
    }
    
    /// TVC 사이 간격 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 23, bottom: 12, right: 24))
    }
}

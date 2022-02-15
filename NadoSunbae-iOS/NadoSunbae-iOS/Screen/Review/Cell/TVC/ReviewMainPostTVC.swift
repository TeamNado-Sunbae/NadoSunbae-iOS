//
//  ReviewMainPostTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewMainPostTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var majorNameLabel: UILabel!
    @IBOutlet weak var firstMajorStartLabel: UILabel!
    @IBOutlet weak var secondMajorNameLabel: UILabel!
    @IBOutlet weak var secondMajorStartLabel: UILabel!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var tagCV: UICollectionView!
    
    // MARK: Properties
    var tagImgList: [ReviewTagList] = []
    
    // MARK: Life Cycle Part
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        registerCVC()
        setUpCV()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// CVC 재사용 문제 해결을 위한 reload
    override func prepareForReuse() {
        tagCV.reloadData()
    }
}

// MARK: - UI
extension ReviewMainPostTVC {
    private func configureUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray0.cgColor
        contentView.backgroundColor = .white
    }
    
    /// TVC 사이 간격 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
    }
}

// MARK: - Custom Methods
extension ReviewMainPostTVC {
    
    /// 리스트 데이터 세팅 함수
    func setData(postData: ReviewMainPostListData) {
        dateLabel.text = postData.createdAt.serverTimeToString(forUse: .forDefault)
        titleLabel.text = postData.oneLineReview
        nickNameLabel.text = postData.writer.nickname
        likeCountLabel.text = "\(postData.like.likeCount)"
        majorNameLabel.text = postData.writer.firstMajorName
        secondMajorNameLabel.text = postData.writer.secondMajorName
        firstMajorStartLabel.text = postData.writer.firstMajorStart
        secondMajorStartLabel.text = postData.writer.secondMajorStart == "미진입" ? "" : postData.writer.secondMajorStart
        likeImgView.image = postData.like.isLiked ? UIImage(named: "heart_filled") : UIImage(named: "btn_heart")
    }
    
    private func registerCVC() {
        ReviewPostTagCVC.register(target: tagCV)
    }
    
    private func setUpCV() {
        tagCV.dataSource = self
        tagCV.delegate = self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReviewMainPostTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var tagWidth: Int?
        
        // TODO: 서버통신 시 태그 이름으로 접근
        if tagImgList[indexPath.row].tagName == "꿀팁" {
            tagWidth = 35
        } else if tagImgList[indexPath.row].tagName == "뭘 배우나요?" {
            tagWidth = 75
        } else {
            tagWidth = 59
        }
        return CGSize(width: tagWidth ?? 59, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewMainPostTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagImgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewPostTagCVC.className, for: indexPath) as? ReviewPostTagCVC else { return UICollectionViewCell() }
        cell.setData(tagData: tagImgList[indexPath.row])
        return cell
    }   
}


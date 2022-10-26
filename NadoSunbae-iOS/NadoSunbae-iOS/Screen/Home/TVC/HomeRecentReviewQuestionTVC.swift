//
//  HomeRecentReviewQuestionTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

enum HomeRecentTVCType {
    case review
    case personalQuestion
}

final class HomeRecentReviewQuestionTVC: BaseTVC {
    
    // MARK: Components
    private let recentCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Properties
    private lazy var CVFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 16
        $0.sectionInset = .zero
        $0.itemSize = CGSize.init(width: (screenWidth - 32) * 2 / 3, height: 153)
    }
    var recentReviewList: HomeRecentReviewResponseData = []
    var recentPersonalQuestionList: [PostListResModel] = []
    var recentType: HomeRecentTVCType?
    var sendHomeRecentDataDelegate: SendHomeRecentDataDelegate?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setRecentCV()
        setData(type: recentType ?? .review)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveReloadNotification(_:)), name: Notification.Name.reloadHomeRecentCell, object: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setData(type: recentType ?? .review)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setRecentCV() {
        recentCV.dataSource = self
        recentCV.delegate = self
        
        recentCV.collectionViewLayout = CVFlowLayout
        recentCV.register(HomeRecentReviewQuestionCVC.self, forCellWithReuseIdentifier: HomeRecentReviewQuestionCVC.className)
    }
    
    private func setData(type: HomeRecentTVCType) {
        switch type {
        case .review:
            getAllReviewList()
        case .personalQuestion:
            debugPrint("setData question")
            getRecentPersonalQuestionList()
        }
    }
    
    @objc func didReceiveReloadNotification(_ notification: Notification) {
        setData(type: recentType ?? .review)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeRecentReviewQuestionTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch recentType {
        case .review:
            return recentReviewList.count
        case .personalQuestion:
            return recentPersonalQuestionList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecentReviewQuestionCVC.className, for: indexPath) as? HomeRecentReviewQuestionCVC else { return UICollectionViewCell() }
        switch recentType {
        case .review:
            cell.setRecentReviewData(data: recentReviewList[indexPath.row])
        case .personalQuestion:
            cell.setRecentPersonalQuestionData(data: recentPersonalQuestionList[indexPath.row])
        default: break
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeRecentReviewQuestionTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch recentType {
        case .review:
            sendHomeRecentDataDelegate?.sendRecentPostId(id: recentReviewList[indexPath.row].id, type: .review, isAuthorized: false)
        case .personalQuestion:
            sendHomeRecentDataDelegate?.sendRecentPostId(id: recentPersonalQuestionList[indexPath.row].postID, type: .personalQuestion, isAuthorized: recentPersonalQuestionList[indexPath.row].isAuthorized ??  false)
        default: break
        }
    }
}

// MARK: - UI
extension HomeRecentReviewQuestionTVC {
    private func configureUI() {
        contentView.addSubviews([recentCV])
        
        recentCV.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

// MARK: - Network
extension HomeRecentReviewQuestionTVC {
    private func getAllReviewList() {
        HomeAPI.shared.getAllReviewList { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? HomeRecentReviewResponseData {
                    self.recentReviewList = []
                    if data.count >= 5 {
                        for i in 0..<5 {
                            self.recentReviewList.append(data[i])
                        }
                    } else {
                        for i in 0..<data.count {
                            self.recentReviewList.append(data[i])
                        }
                    }
                    self.recentCV.reloadData()
                }
            default:
                debugPrint(#function, "network error")
            }
        }
    }
    
    private func getRecentPersonalQuestionList() {
        PublicAPI.shared.getPostList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), majorID: 0, filter: .questionToPerson, sort: "recent", search: "") { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? [PostListResModel] {
                    self.recentPersonalQuestionList = []
                    if data.count >= 5 {
                        for i in 0..<5 {
                            self.recentPersonalQuestionList.append(data[i])
                        }
                    } else {
                        for i in 0..<data.count {
                            self.recentPersonalQuestionList.append(data[i])
                        }
                    }
                    self.recentCV.reloadData()
                }
            default:
                debugPrint(#function, "network error")
            }
        }
    }
}

//
//  MypageReviewLikeVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/07.
//

import UIKit
import SnapKit
import Then

class MypageReviewLikeVC: BaseVC {
    
    // MARK: Properties
    private var segmentView = NadoSegmentView().then {
        $0.firstBtn.setTitleWithStyle(title: "후기", size: 14.0)
        $0.secondBtn.setTitleWithStyle(title: "질문", size: 14.0)
        $0.thirdBtn.setTitleWithStyle(title: "정보", size: 14.0)
        $0.firstBtn.isActivated = true
        $0.firstBtn.isEnabled = false
        [$0.secondBtn, $0.thirdBtn].forEach {
            $0.isActivated = false
            $0.isEnabled = true
        }
    }
    
    private let likeReviewListSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    
    private let likeReviewListTV = UITableView().then {
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    // MARK: Properties
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    private var likeReviewList: [MypageLikeReviewDataModel] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTapSegmentBtn()
        setUpDelegate()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestGetLikeReviewListData()
    }
}

// MARK: - UI
extension MypageReviewLikeVC {
    func configureUI() {
        view.addSubview(likeReviewListSV)
        likeReviewListSV.addSubview(contentView)
        contentView.addSubviews([segmentView, likeReviewListTV])
        
        likeReviewListSV.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        segmentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38.adjustedH)
        }
        
        likeReviewListTV.snp.makeConstraints {
            $0.top.equalTo(segmentView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(500)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        view.backgroundColor = .paleGray
    }
}

// MARK: - Custom Methods
extension MypageReviewLikeVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        likeReviewListTV.delegate = self
        likeReviewListTV.dataSource = self
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        likeReviewListTV.register(QuestionEmptyTVC.self, forCellReuseIdentifier: QuestionEmptyTVC.className)
        ReviewMainPostTVC.register(target: likeReviewListTV)
    }
    
    /// segment를 눌렀을 때 실행되는 액션 메서드
    func setUpTapSegmentBtn() {
        segmentView.firstBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 0)
            }
        }
        segmentView.secondBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 1)
            }
        }
        segmentView.thirdBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 2)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MypageReviewLikeVC: UITableViewDataSource {
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likeReviewList.count == 0 {
            return 1
        } else {
            return likeReviewList.count
        }
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if likeReviewList.count == 0 {
            let emptyCell = QuestionEmptyTVC()
            emptyCell.setUpEmptyQuestionLabelText(text: "좋아요한 후기글이 없습니다.")
            return emptyCell
        } else {
            guard let likeReviewCell = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className, for: indexPath) as? ReviewMainPostTVC else { return UITableViewCell() }
            likeReviewCell.tagImgList = likeReviewList[indexPath.row].tagList
            likeReviewCell.setMypageReviewLikeData(postData: likeReviewList[indexPath.row])
            likeReviewCell.layoutIfNeeded()
            return likeReviewCell
        }
    }
}

// MARK: - UITableViewDelegate
extension MypageReviewLikeVC: UITableViewDelegate {
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if likeReviewList.count == 0 {
            return 515
        } else {
            return 156.adjustedH
        }
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// 후기글 작성하지 않은 유저라면 후기글 열람 제한
        if !(UserDefaults.standard.bool(forKey: UserDefaults.Keys.IsReviewed)) {
            showRestrictionAlert()
        } else if likeReviewList.count != 0 {
            guard let reviewDetailVC = UIStoryboard.init(name: Identifiers.ReviewDetailSB, bundle: nil).instantiateViewController(withIdentifier: ReviewDetailVC.className) as? ReviewDetailVC else { return }
            reviewDetailVC.postId = likeReviewList[indexPath.row].postID
            self.navigationController?.pushViewController(reviewDetailVC, animated: true)
        }
    }
}

// MARK: - Network
extension MypageReviewLikeVC {
    
    /// 후기글 좋아요 목록 조회 API 요청 메서드
    func requestGetLikeReviewListData() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getMypageMyLikeReviewListAPI() { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageLikeReviewData {
                    self.likeReviewList = data.likePostList
                    self.likeReviewListTV.reloadData()
                    self.likeReviewListTV.layoutIfNeeded()
                    self.likeReviewListTV.snp.updateConstraints {
                        $0.height.equalTo(self.likeReviewListTV.contentSize.height)
                    }
                }
                self.activityIndicator.stopAnimating()
            case .requestErr(let msg):
                self.activityIndicator.stopAnimating()
                if let message = msg as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}


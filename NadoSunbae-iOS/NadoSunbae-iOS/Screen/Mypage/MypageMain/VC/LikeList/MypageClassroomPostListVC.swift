//
//  MypageClassroomPostListVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/07.
//

import UIKit
import SnapKit
import Then

class MypageClassroomPostListVC: BaseVC {
    
    // MARK: Properties
    private var segmentView = NadoSegmentView().then {
        $0.firstBtn.setTitleWithStyle(title: "후기", size: 14.0)
        $0.secondBtn.setTitleWithStyle(title: "질문", size: 14.0)
        $0.thirdBtn.setTitleWithStyle(title: "정보", size: 14.0)
    }
    
    private let likePostListSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    
    private let likePostListTV = UITableView().then {
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 8
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    var likePostType = MypageLikePostType.question
    private var likePostList: [MypageLikePostDataModel] = []
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpDelegate()
        registerCell()
        setSegmentStateByPostType()
        setUpTapSegmentBtn()
        addActivateIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestGetLikePostListData(postType: likePostType)
    }
}

// MARK: - UI
extension MypageClassroomPostListVC {
    func configureUI() {
        view.addSubview(likePostListSV)
        likePostListSV.addSubview(contentView)
        contentView.addSubviews([segmentView, likePostListTV])
        
        likePostListSV.snp.makeConstraints {
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
        
        likePostListTV.snp.makeConstraints {
            $0.top.equalTo(segmentView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(500)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        view.backgroundColor = .paleGray
        likePostListTV.backgroundColor = .white
        likePostListTV.separatorColor = .gray1
    }
}

// MARK: - Custom Methods
extension MypageClassroomPostListVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        likePostListTV.delegate = self
        likePostListTV.dataSource = self
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        likePostListTV.register(BaseQuestionTVC.self, forCellReuseIdentifier: BaseQuestionTVC.className)
        likePostListTV.register(QuestionEmptyTVC.self, forCellReuseIdentifier: QuestionEmptyTVC.className)
    }
    
    /// activityIndicator 설정 메서드
    private func addActivateIndicator() {
        activityIndicator.center = CGPoint(x: self.view.center.x, y: view.center.y - 106)
        view.addSubview(self.activityIndicator)
    }
    
    /// likePostType에 따라 Segment의 isActivated, isEnabled 상태를 지정하는 메서드
    private func setSegmentStateByPostType() {
        switch likePostType {
        case .review:
            break
        case .question:
            segmentView.secondBtn.isActivated = true
            segmentView.secondBtn.isEnabled = false
            [segmentView.firstBtn, segmentView.thirdBtn].forEach {
                $0.isActivated = false
                $0.isEnabled = true
            }
        case .information:
            segmentView.thirdBtn.isActivated = true
            segmentView.thirdBtn.isEnabled = false
            [segmentView.firstBtn, segmentView.secondBtn].forEach {
                $0.isActivated = false
                $0.isEnabled = true
            }
        }
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
extension MypageClassroomPostListVC: UITableViewDataSource {
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likePostList.count == 0 {
            return 1
        } else {
            return likePostList.count
        }
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if likePostList.count == 0 {
            let emptyCell = QuestionEmptyTVC()
            emptyCell.setUpEmptyQuestionLabelText(text: likePostType == .question ? "좋아요한 질문글이 없습니다." : "좋아요한 정보글이 없습니다.")
            return emptyCell
        } else {
            guard let postCell = tableView.dequeueReusableCell(withIdentifier: BaseQuestionTVC.className, for: indexPath) as? BaseQuestionTVC else { return UITableViewCell() }
            postCell.setMypageLikeData(data: likePostList[indexPath.row])
            postCell.backgroundColor = .white
            postCell.layoutIfNeeded()
            return postCell
        }
    }
}

// MARK: - UITableViewDelegate
extension MypageClassroomPostListVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if likePostList.count == 0 {
            return 515
        } else {
            return 126
        }
    }
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if likePostList.count == 0 {
            return 515
        } else {
            return UITableView.automaticDimension
        }
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch likePostType {
            
        case .review:
            break
        case .question:
            guard let questionDetailVC = UIStoryboard.init(name: Identifiers.QuestionChatSB, bundle: nil).instantiateViewController(withIdentifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
            
            if likePostList.count != 0 {
                questionDetailVC.postID = likePostList[indexPath.row].postID
                questionDetailVC.questionType = likePostList[indexPath.row].postTypeID == 3 ? .group : .personal
                questionDetailVC.naviStyle = .push
                questionDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(questionDetailVC, animated: true)
            }
        case .information:
            guard let infoDetailVC = UIStoryboard.init(name: Identifiers.InfoSB, bundle: nil).instantiateViewController(withIdentifier: InfoDetailVC.className) as? InfoDetailVC else { return }
            
            if likePostList.count != 0 {
                infoDetailVC.postID = likePostList[indexPath.row].postID
                infoDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(infoDetailVC, animated: true)
            }
        }
    }
}

// MARK: - Network
extension MypageClassroomPostListVC {
    
    /// 질문, 정보글 좋아요 목록 조회 API 요청 메서드
    func requestGetLikePostListData(postType: MypageLikePostType) {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getMypageMyLikePostListAPI(postType: postType) { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageLikePostData {
                    self.likePostList = data.likePostList
                    self.likePostListTV.reloadData()
                    self.likePostListTV.layoutIfNeeded()
                    self.likePostListTV.rowHeight = UITableView.automaticDimension
                    self.likePostListTV.snp.updateConstraints {
                        $0.height.equalTo(self.likePostListTV.contentSize.height)
                    }
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "서버 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "서버 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}


//
//  InfoDetailVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/13.
//

import UIKit
import SnapKit
import Then
import SafariServices

class InfoDetailVC: BaseVC {
    
    // MARK: Properties
    private let infoDetailNaviBar = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backWithCenterTitle)
    }
    
    private let infoDetailTV = UITableView().then {
        $0.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    var chatPostID: Int?
    var userID: Int?
    var userType: Int?
    var questionerID: Int?
    var infoDetailData: InfoDetailDataModel?
    var infoDetailCommentData: [InfoDetailCommentList] = []
    var infoDetailLikeData: Like?

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerXib()
        setUpTV()
        setUpNaviStyle()
        addActivateIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        optionalBindingData()
    }
}

// MARK: - UI
extension InfoDetailVC {
    private func configureUI() {
        self.view.addSubviews([infoDetailNaviBar, infoDetailTV])
        
        infoDetailNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        infoDetailTV.snp.makeConstraints {
            $0.top.equalTo(infoDetailNaviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(236)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Custom Methods
extension InfoDetailVC {
    
    /// infoDetailTV 구성 메서드
    private func setUpTV() {
        infoDetailTV.dataSource = self
        infoDetailTV.allowsSelection = false
        infoDetailTV.separatorStyle = .none
        infoDetailTV.rowHeight  = UITableView.automaticDimension
        infoDetailTV.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        infoDetailTV.backgroundColor = .paleGray
    }
    
    /// xib 등록 메서드
    private func registerXib() {
        InfoQuestionTVC.register(target: infoDetailTV)
        InfoCommentTVC.register(target: infoDetailTV)
    }
    
    /// 네비 set 메서드
    private func setUpNaviStyle() {
        infoDetailNaviBar.titleLabel.text = "정보글"
        infoDetailNaviBar.rightCustomBtn.setImgByName(name: "btnMoreVertChatGray", selectedName: "btnMoreVertChatGray")
        infoDetailNaviBar.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 전달받은 데이터를 바인딩하는 메서드
    private func optionalBindingData() {
        if let chatPostID = chatPostID {
            DispatchQueue.main.async {
                self.requestGetDetailInfoData(chatPostID: chatPostID)
            }
        }
    }
    
    /// ActivateIndicator 추가 메서드
    private func addActivateIndicator() {
        activityIndicator.center = CGPoint(x: self.view.center.x, y: view.center.y)
        view.addSubview(self.activityIndicator)
    }
}

// MARK: - UITableViewDataSource
extension InfoDetailVC: UITableViewDataSource {
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + infoDetailCommentData.count
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let infoQuestionCell = tableView.dequeueReusableCell(withIdentifier: InfoQuestionTVC.className, for: indexPath) as? InfoQuestionTVC,
              let infoCommentCell = tableView.dequeueReusableCell(withIdentifier: InfoCommentTVC.className, for: indexPath) as? InfoCommentTVC else { return UITableViewCell() }

        /// 정보글 원글 Cell
        if indexPath.row == 0 {
            infoQuestionCell.bindData(infoDetailData ?? InfoDetailDataModel(post: InfoDetailPost(postID: 0, title: "", content: "", createdAt: ""), writer: InfoDetailWriter(writerID: 0, profileImageID: 0, nickname: "", firstMajorName: "", firstMajorStart: "", secondMajorName: "", secondMajorStart: "", isPostWriter: false), like: Like(isLiked: false, likeCount: 0), commentCount: 0, commentList: []))
    
            infoQuestionCell.tapLikeBtnAction = { [unowned self] in
                requestPostLikeData(chatID: chatPostID ?? 0, postTypeID: .info)
            }
            
            infoQuestionCell.interactURL = { url in
                let safariView: SFSafariViewController = SFSafariViewController(url: url)
                self.present(safariView, animated: true, completion: nil)
            }
            return infoQuestionCell
        } else if indexPath.row == 1 {
            /// 정보글 댓글 수 header Cell
            let infoCommentHeaderCell = InfoCommentHeaderTVC()
            infoCommentHeaderCell.bindData(commentCount: infoDetailData?.commentCount ?? -1)
            return infoCommentHeaderCell
        }
        else {
            /// 정보글 댓글 Cell
            infoCommentCell.bindData(model: infoDetailCommentData[indexPath.row - 2])
            infoCommentCell.tapMoreInfoBtn = { [unowned self] in
                // TODO: 추후에 권한 분기처리 예정
                self.makeAlertWithCancel(okTitle: "신고", okAction: { _ in
                    // TODO: 추후에 기능 추가 예정
                })
            }
            
            infoQuestionCell.interactURL = { url in
                let safariView: SFSafariViewController = SFSafariViewController(url: url)
                self.present(safariView, animated: true, completion: nil)
            }
            return infoCommentCell
        }
    }
}

// MARK: - UITableViewDelegate
extension InfoDetailVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - Network
extension InfoDetailVC {
    
    /// 정보글 상세 조회 API 요청 메서드
    func requestGetDetailInfoData(chatPostID: Int) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.getInfoDetailAPI(chatPostID: chatPostID) { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? InfoDetailDataModel {
                    self.infoDetailData = data
                    self.infoDetailCommentData = data.commentList
                    self.userID = UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID)
                    DispatchQueue.main.async {
                        self.infoDetailTV.reloadData()
                    }
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 1:1질문, 전체 질문, 정보글에 댓글 등록 API 요청 메서드
    func requestCreateComment(chatPostID: Int, comment: String) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.createCommentAPI(chatID: chatPostID, comment: comment) { networkResult in
            switch networkResult {
            case .success(let res):
                if let _ = res as? AddCommentData {
                    DispatchQueue.main.async {
                        self.requestGetDetailInfoData(chatPostID: chatPostID)
                        self.activityIndicator.stopAnimating()
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 좋아요 API 요청 메서드
    func requestPostLikeData(chatID: Int, postTypeID: QuestionType) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.postClassroomLikeAPI(chatPostID: chatID, postTypeID: postTypeID.rawValue) { networkResult in
            switch networkResult {
            case .success(let res):
                if let _ = res as? PostLikeResModel {
                    DispatchQueue.main.async {
                        self.requestGetDetailInfoData(chatPostID: self.chatPostID ?? 0)
                    }
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

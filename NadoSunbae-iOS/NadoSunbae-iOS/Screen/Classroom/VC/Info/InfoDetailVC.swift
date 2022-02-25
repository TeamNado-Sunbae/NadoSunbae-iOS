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
    
    // MARK: IBOutlet
    @IBOutlet var infoDetailNaviBar: NadoSunbaeNaviBar! {
        didSet {
            infoDetailNaviBar.setUpNaviStyle(state: .backWithCenterTitle)
        }
    }
    
    @IBOutlet var infoDetailTV: UITableView! {
        didSet {
            infoDetailTV.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
            infoDetailTV.removeSeparatorsOfEmptyCellsAndLastCell()
            infoDetailTV.dataSource = self
            infoDetailTV.allowsSelection = false
            infoDetailTV.rowHeight  = UITableView.automaticDimension
            infoDetailTV.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
            infoDetailTV.backgroundColor = .paleGray
        }
    }
    
    @IBOutlet var commentTextView: UITextView! {
        didSet {
            commentTextView.delegate = self
            commentTextView.isScrollEnabled = false
            commentTextView.layer.cornerRadius = 18
            commentTextView.layer.borderWidth = 1
            commentTextView.layer.borderColor = UIColor.gray1.cgColor
            commentTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 15)
            commentTextView.sizeToFit()
        }
    }
    
    @IBOutlet var commentTextViewHeight: NSLayoutConstraint!
    @IBOutlet var commentTextViewBottom: NSLayoutConstraint!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var sendBtnBottom: NSLayoutConstraint!
    
    // MARK: Properties
    var postID: Int?
    var userID: Int?
    var questionerID: Int?
    private var infoDetailData: InfoDetailDataModel?
    private var infoDetailCommentData: [InfoDetailCommentList] = []
    private var infoDetailLikeData: Like?
    private let screenHeight = UIScreen.main.bounds.size.height
    private var isCommentSend: Bool = false
    private var isTextViewEmpty: Bool = true
    private var sendTextViewLineCount: Int = 1
    private var isWriter: Bool?
    private let textViewMaxHeight: CGFloat = 85.adjustedH
    private let whiteBackView = UIView()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        setUpNaviStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        addKeyboardObserver()
        optionalBindingData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    // MARK: IBOutlet
    @IBAction func tapSendBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.isCommentSend = true
            self.requestCreateComment(postID: self.postID ?? 0, comment: self.commentTextView.text)
        }
    }
}

// MARK: - UI
extension InfoDetailVC {
    
    /// 첫 진입시 데이터 로딩되는 동안 backView를 띄우기 위한 whiteBackView 구성 메서드
    private func configureWhiteBackView() {
        self.view.addSubview(whiteBackView)
        addActivateIndicator()
        
        whiteBackView.backgroundColor = .white
        whiteBackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    /// whiteBackView remove 메서드
    private func removeWhiteBackView() {
        whiteBackView.removeFromSuperview()
    }
}

// MARK: - Custom Methods
extension InfoDetailVC {
    
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
        infoDetailNaviBar.rightCustomBtn.press {
            if self.isWriter == true {
                self.makeTwoAlertWithCancel(okTitle: "수정", secondOkTitle: "삭제", okAction: { _ in
                    self.presentWriteQuestionVC()
                }, secondOkAction: { _ in
                    
                })
            }
            self.makeAlertWithCancel(okTitle: "신고", okAction: { _ in
                // TODO: 추후에 신고 기능 추가 예정
            })
        }
    }
    
    /// 전달받은 데이터를 바인딩하는 메서드
    private func optionalBindingData() {
        if let postID = postID {
            DispatchQueue.main.async {
                self.requestGetDetailInfoData(postID: postID, addLoadBackView: true)
            }
        }
    }
    
    /// ActivateIndicator 추가 메서드
    private func addActivateIndicator() {
        activityIndicator.center = CGPoint(x: self.view.center.x, y: view.center.y)
        view.addSubview(self.activityIndicator)
    }
    
    /// 전송 버튼의 상태를 setUp하는 메서드
    private func setUpSendBtnEnabledState() {
        sendBtn.isEnabled = isTextViewEmpty ? false : true
    }
    
    /// 전송 영역 TextView Height 조정하는 메서드
    private func sendAreaDynamicHeight(textView: UITextView) {
        if textView.contentSize.height >= self.textViewMaxHeight {
            commentTextViewHeight.constant = self.textViewMaxHeight
            textView.isScrollEnabled = true
        } else {
            commentTextViewHeight.constant = textView.contentSize.height
            textView.isScrollEnabled = false
        }
    }
    
    /// 전송 영역 height값이 커짐에 따라 TableView contentOffset 조정하는 메서드
    private func adjustTVContentOffset(textView: UITextView) {
        var isLineAdded = true
        
        if sendTextViewLineCount != textView.numberOfLines() && textView.numberOfLines() > 1 {
            isLineAdded = sendTextViewLineCount > textView.numberOfLines() ? false : true
            
            if isLineAdded {
                if textView.contentSize.height <= self.textViewMaxHeight {
                    self.infoDetailTV.contentOffset.y += 38
                }
            }
        }
        sendTextViewLineCount = textView.numberOfLines()
    }
    
    /// TextView의 placeholder 지정하는 메서드
    private func configueTextViewPlaceholder() {
        commentTextView.endEditing(true)
        commentTextView.text = "답글쓰기"
        commentTextView.textColor = .gray2
        commentTextView.backgroundColor = .gray0
    }
    
    /// 정보글 원글을 수정하기 위해 WriteQuestionVC로 화면전환하는 메서드
    private func presentWriteQuestionVC() {
        let writeQuestionSB: UIStoryboard = UIStoryboard(name: Identifiers.WriteQusetionSB, bundle: nil)
        guard let editPostVC = writeQuestionSB.instantiateViewController(identifier: WriteQuestionVC.className) as? WriteQuestionVC else { return }
        
        editPostVC.questionType = .info
        editPostVC.isEditState = true
        editPostVC.postID = self.postID
        editPostVC.originTitle = self.infoDetailData?.post.title
        editPostVC.originContent = self.infoDetailData?.post.content
        editPostVC.modalPresentationStyle = .fullScreen
        
        self.present(editPostVC, animated: true, completion: nil)
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
                requestPostLikeData(postID: postID ?? 0, postTypeID: .info)
            }
            
            infoQuestionCell.interactURL = { url in
                let safariView: SFSafariViewController = SFSafariViewController(url: url)
                self.present(safariView, animated: true, completion: nil)
            }
            
            infoQuestionCell.separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
            return infoQuestionCell
        } else if indexPath.row == 1 {
            /// 정보글 댓글 수 header Cell
            let infoCommentHeaderCell = InfoCommentHeaderTVC()
            infoCommentHeaderCell.bindData(commentCount: infoDetailData?.commentCount ?? 0)
            infoCommentHeaderCell.separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
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
            
            infoCommentCell.interactURL = { url in
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

// MARK: - UITextViewDelegate
extension InfoDetailVC: UITextViewDelegate {
    
    /// textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        isTextViewEmpty = textView.text.isEmpty ? true : false
        sendAreaDynamicHeight(textView: textView)
        adjustTVContentOffset(textView: textView)
        setUpSendBtnEnabledState()
    }
    
    /// textViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray2 {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.backgroundColor = .white
        }
    }
    
    /// textViewDidEndEditing
    func textViewDidEndEditing(_ textView: UITextView) {
        isTextViewEmpty = textView.text.isEmpty ? true : false
        setUpSendBtnEnabledState()
        configueTextViewPlaceholder()
    }
}


// MARK: - Keyboard
extension InfoDetailVC {
    
    /// Keyboard Observer add 메서드
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if screenHeight == 667 {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                commentTextViewBottom.constant = keyboardSize.height + 6
                sendBtnBottom.constant = keyboardSize.height + 1
            }
        } else {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                commentTextViewBottom.constant = keyboardSize.height - 25
                sendBtnBottom.constant = keyboardSize.height - 30
            }
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            commentTextViewBottom.constant = 5
            sendBtnBottom.constant = 0
            infoDetailTV.fitContentInset(inset: .zero)
        }
    }
    
    /// Keyboard Observer remove 메서드
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Network
extension InfoDetailVC {
    
    /// 정보글 상세 조회 API 요청 메서드
    func requestGetDetailInfoData(postID: Int, addLoadBackView: Bool) {
        addLoadBackView ? self.configureWhiteBackView() : nil
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.getInfoDetailAPI(postID: postID) { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? InfoDetailDataModel {
                    self.infoDetailData = data
                    self.infoDetailCommentData = data.commentList
                    self.userID = UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID)
                    self.isWriter = (self.userID == self.infoDetailData?.writer.writerID) ? true : false
                    
                    DispatchQueue.main.async {
                        self.infoDetailTV.reloadData()
                        self.setUpSendBtnEnabledState()
                        self.configueTextViewPlaceholder()
                        addLoadBackView ? self.removeWhiteBackView() : nil
                        self.activityIndicator.stopAnimating()
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 정보글에 댓글 등록 API 요청 메서드
    func requestCreateComment(postID: Int, comment: String) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.createCommentAPI(postID: postID, comment: comment) { networkResult in
            switch networkResult {
            case .success(let res):
                if let _ = res as? AddCommentData {
                    DispatchQueue.main.async {
                        self.requestGetDetailInfoData(postID: postID, addLoadBackView: false)
                        self.activityIndicator.stopAnimating()
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 좋아요 API 요청 메서드
    func requestPostLikeData(postID: Int, postTypeID: QuestionType) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.postClassroomLikeAPI(postID: postID, postTypeID: postTypeID.rawValue) { networkResult in
            switch networkResult {
            case .success(let res):
                if let _ = res as? PostLikeResModel {
                    DispatchQueue.main.async {
                        self.requestGetDetailInfoData(postID: self.postID ?? 0, addLoadBackView: false)
                    }
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

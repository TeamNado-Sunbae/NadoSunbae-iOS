//
//  DefaultQuestionChatVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/10.
//

import UIKit

class DefaultQuestionChatVC: BaseVC {
    
    // MARK: IBOutlet
    @IBOutlet var sendAreaTextViewHeight: NSLayoutConstraint!
    @IBOutlet var animationTop: NSLayoutConstraint!
    @IBOutlet var animationLeading: NSLayoutConstraint!
    @IBOutlet var animationTrailing: NSLayoutConstraint!
    @IBOutlet var animationWidth: NSLayoutConstraint!
    @IBOutlet var sendAreaTextViewBottom: NSLayoutConstraint!
    @IBOutlet var sendBtnBottom: NSLayoutConstraint!
    @IBOutlet var defaultQuestionChatTV: UITableView! {
        didSet {
            defaultQuestionChatTV.dataSource = self
            defaultQuestionChatTV.allowsSelection = false
            defaultQuestionChatTV.separatorStyle = .none
            defaultQuestionChatTV.rowHeight  = UITableView.automaticDimension
        }
    }
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var animationLabel: UILabel! {
        didSet {
            animationLabel.isHidden = true
            animationLabel.layer.cornerRadius = 4
            animationLabel.layer.masksToBounds = true
            animationLabel.numberOfLines = 0
            animationLabel.font = .PretendardR(size: 14.0)
            animationLabel.sizeToFit()
        }
    }
    
    @IBOutlet var sendAreaTextView: UITextView! {
        didSet {
            sendAreaTextView.delegate = self
            sendAreaTextView.isScrollEnabled = false
            sendAreaTextView.layer.cornerRadius = 18
            sendAreaTextView.layer.borderWidth = 1
            sendAreaTextView.layer.borderColor = UIColor.gray1.cgColor
            sendAreaTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 15)
            configueTextViewPlaceholder(userType: userType ?? -1, questionType: questionType ?? .personal)
            sendAreaTextView.sizeToFit()
        }
    }
    
    @IBOutlet var questionNaviBar: NadoSunbaeNaviBar!
    
    // MARK: Properties
    var editIndex: [Int]?
    var moreBtnTapIndex: [Int]?
    var naviStyle: NaviType?
    var questionType: QuestionType?
    var questionerID: Int?
    var answererID: Int?
    var userID: Int?
    var userType: Int?
    var postID: Int?
    private var qnaType: QnAType?
    private var questionChatData: [ClassroomMessageList] = []
    private var questionLikeData: Like?
    private var isCommentEdited: Bool = false
    private var editedCommentIndexPath: [IndexPath] = []
    private var isCommentSend: Bool = false
    private var actionSheetString: [String] = []
    private let screenHeight = UIScreen.main.bounds.size.height
    private var isTextViewEmpty: Bool = true
    private var sendTextViewLineCount: Int = 1
    private let textViewMaxHeight: CGFloat = 85
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNaviInitStyle()
        registerXib()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        sendAreaTextView.centerVertically()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
        optionalBindingData()
        hideTabbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    // MARK: IBAction
    @IBAction func tapSendBtn(_ sender: UIButton) {
        if !isTextViewEmpty {
            if userType == 0 {
                leftSendAnimation(text: ".............")
            } else {
                rightSendAnimation(text: ".............")
            }
            
            DispatchQueue.main.async {
                self.isCommentSend = true
                self.requestCreateComment(postID: self.postID ?? 0, comment: self.sendAreaTextView.text)
            }
        }
    }
}

// MARK: - UI
extension DefaultQuestionChatVC {
    
    /// 메시지 보내기: 기본 애니메이션 동작 메서드
    private func bubbleAnimation(_ duration: TimeInterval, _ topConstraint: CGFloat, _ widthConstraint: CGFloat, _ trailingConstraint: CGFloat , _ backgroundColor: UIColor, _ finishedTopConstraint: CGFloat, _ finishedTrailingConstraint: CGFloat, _ finishedWidthConstraint: CGFloat, _ finishedLeadingConstraint: CGFloat, _ finishedBackgroundColor: UIColor) {
        UIView.animate(withDuration: duration, animations: {
            self.animationLabel.isHidden = false
            self.animationTop.constant = topConstraint
            self.animationWidth.constant = widthConstraint
            self.animationTrailing.constant = trailingConstraint
            self.animationLabel.backgroundColor = backgroundColor
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.animationLabel.isHidden = true
            self.animationTop.constant = finishedTopConstraint
            self.animationTrailing.constant = finishedTrailingConstraint
            self.animationWidth.constant = finishedWidthConstraint
            self.animationLeading.constant = finishedLeadingConstraint
            self.animationLabel.backgroundColor = finishedBackgroundColor
        })
    }
    
    /// 메시지 보내기: 기본 애니메이션 확장 -> 왼쪽 버블 애니메이션 메서드 (constraint 조정)
    private func leftSendAnimation(text: String) {
        var animateConstraint: CGFloat = 0
        animationLabel.text = text
        animationLabel.numberOfLines = 0
        animationLeading.constant = 15
        animationTop.constant = self.view.frame.height - animationLabel.frame.height
        animateConstraint = self.view.frame.height - 175
        
        bubbleAnimation(0.5, animateConstraint - 35, 50,
                        200, .white, self.view.frame.height - 200, 30, 100, 50, .gray2)
    }
    
    /// 메시지 보내기: 기본 애니메이션 확장 -> 오른쪽 버블 애니메이션 메서드 (constraint 조정)
    private func rightSendAnimation(text: String) {
        var constraint: CGFloat = 0, animateConstraint: CGFloat = 0
        animationLabel.text = text
        animationLabel.numberOfLines = 0
        animationTop.constant = self.view.frame.height - animationLabel.frame.height
        animationLeading.constant = self.view.frame.width - animationLabel.intrinsicContentSize.width
        constraint = CGFloat(self.view.frame.height - defaultQuestionChatTV.contentSize.height)
        
        if self.view.frame.height - constraint < self.view.frame.height - 200 {
            animateConstraint = self.view.frame.height - constraint
        }
        else {
            animateConstraint = self.view.frame.height - 175
        }
        
        bubbleAnimation(0.5, animateConstraint - 35, self.animationLabel.intrinsicContentSize.width + 100, 10, .mainLight, self.view.frame.height - 150, 70, 330, 50, .gray2)
    }
    
    /// userType별로 TextView의 placeholder 지정하는 메서드
    private func configueTextViewPlaceholder(userType: Int, questionType: QuestionType) {
        
        switch questionType {
        case .personal:
            sendAreaTextView.isEditable = (userType == 0 || userType == 1) ? true : false
            sendAreaTextView.text = (userType == 0 || userType == 1) ? "답글쓰기" : "다른 선배 개인 페이지에서는 답글 불가!"
        case .group:
            sendAreaTextView.isEditable = true
            sendAreaTextView.text = "답글쓰기"
        default:
            print("info or Review")
        }
        
        sendAreaTextView.endEditing(true)
        sendAreaTextView.textColor = .gray2
        sendAreaTextView.backgroundColor = .gray0
    }
    
    private func scrollTVtoBottom(animate: Bool) {
        DispatchQueue.main.async {
            let lastSectionIndex = self.defaultQuestionChatTV!.numberOfSections - 1
            let lastRowIndex = self.defaultQuestionChatTV.numberOfRows(inSection: lastSectionIndex) - 1
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            self.defaultQuestionChatTV.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.none, animated: animate)
        }
    }
}

// MARK: - Custom Methods
extension DefaultQuestionChatVC {
    
    /// TableView에 Xib 등록하는 메서드
    private func registerXib() {
        ClassroomQuestionTVC.register(target: defaultQuestionChatTV)
        ClassroomCommentTVC.register(target: defaultQuestionChatTV)
        ClassroomQuestionEditTVC.register(target: defaultQuestionChatTV)
        ClassroomCommentEditTVC.register(target: defaultQuestionChatTV)
    }
    
    /// 전달받은 데이터에 따라 동적으로 네비 스타일을 구성하는 메서드
    private func setUpNaviInitStyle() {
        if let naviStyle = naviStyle {
            switch naviStyle {
            case .push:
                questionNaviBar.setUpNaviStyle(state: .backWithCenterTitle)
                questionNaviBar.rightCustomBtn.isHidden = true
                
                questionNaviBar.backBtn.press(vibrate: true, for: .touchUpInside) {
                    self.navigationController?.popViewController(animated: true)
                }
                
                if let questionType = questionType {
                    switch questionType {
                    case .personal:
                        questionNaviBar.configureTitleLabel(title: "1:1 질문")
                    case .group:
                        questionNaviBar.configureTitleLabel(title: "질문")
                    case .info:
                        questionNaviBar.configureTitleLabel(title: "정보글")
                    default:
                        print("Review")
                    }
                }
            case .present:
                questionNaviBar.setUpNaviStyle(state: .dismissWithCustomRightBtn)
                questionNaviBar.dismissBtn.press(vibrate: true, for: .touchUpInside) {
                    self.dismiss(animated: true, completion: nil)
                }
                
                if let questionType = questionType {
                    switch questionType {
                    case .personal:
                        questionNaviBar.configureTitleLabel(title: "1:1 질문")
                    case .group:
                        questionNaviBar.configureTitleLabel(title: "질문")
                    case .info:
                        questionNaviBar.configureTitleLabel(title: "정보글")
                    default:
                        print("None-Data")
                    }
                }
            }
        }
    }
    
    /// 유저 유형을 식별하는 메서드
    private func identifyUserType(questionerID: Int, answererID: Int) -> Int {
        return (userID != questionerID && userID != answererID) ? 2 : (userID == questionerID) ? 0 : 1
    }
    
    /// 전송 버튼의 상태를 setUp하는 메서드
    private func setUpSendBtnEnabledState(questionType: QuestionType, textView: UITextView) {
        if isTextViewEmpty {
            sendBtn.isEnabled = false
        } else {
            if questionType == .personal {
                if userType == 2 {
                    sendBtn.isEnabled = false
                } else {
                    sendBtn.isEnabled = true
                }
            } else {
                sendBtn.isEnabled = true
            }
        }
    }
    
    /// 전송 영역 TextView Height 조정하는 메서드
    private func sendAreaDynamicHeight(textView: UITextView) {
        if textView.contentSize.height >= self.textViewMaxHeight {
            sendAreaTextViewHeight.constant = self.textViewMaxHeight
            textView.isScrollEnabled = true
        } else {
            sendAreaTextViewHeight.constant = textView.contentSize.height
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
                    self.defaultQuestionChatTV.contentOffset.y += 38
                }
            }
        }
        sendTextViewLineCount = textView.numberOfLines()
    }
    
    /// ActionSheetCase에 String 배열을 return하는 메서드
    func returnActionSheetType(type: ActionSheetCase) -> [String] {
        switch type {
        case .reportAndDelete:
            return ["신고", "삭제"]
        case .onlyReport:
            return ["신고"]
        case .editAndDelete:
            return ["수정", "삭제"]
        }
    }
    
    /// 전달받은 데이터를 바인딩하는 메서드
    private func optionalBindingData() {
        if let postID = postID {
            DispatchQueue.main.async {
                self.requestGetDetailQuestionData(postID: postID)
            }
        }
    }
    
    /// 나도선배 delete alert를 만드는 메서드
    private func makeNadoDeleteAlert(qnaType: QnAType, commentID: Int, indexPath: [IndexPath]) {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        let alertMsgdict: [QnAType: String] = [
            .question: """
                글을 삭제하시겠습니까?
                """,
            .comment: """
                댓글을 삭제하시겠습니까?
                """
        ]
        
        alert.showNadoAlert(vc: self, message: (qnaType == .question ? alertMsgdict[.question] : alertMsgdict[.comment]) ?? "", confirmBtnTitle: "네", cancelBtnTitle: "아니요")
        alert.confirmBtn.press(vibrate: true, for: .touchUpInside) {
            qnaType == .question ? self.requestDeletePostQuestion(postID: self.postID ?? 0) : self.requestDeletePostComment(commentID: commentID, indexPath: indexPath)
        }
    }
}

// MARK: - UITextViewDelegate
extension DefaultQuestionChatVC: UITextViewDelegate {
    
    /// textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        sendAreaDynamicHeight(textView: textView)
        adjustTVContentOffset(textView: textView)
        isTextViewEmpty = textView.text.isEmpty ? true : false
        setUpSendBtnEnabledState(questionType: questionType ?? .personal, textView: sendAreaTextView)
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
        if textView.text.isEmpty {
            // TODO: 서버통신 후 유저 정보에 따라 분기처리 필요
            configueTextViewPlaceholder(userType: userType ?? -1, questionType: questionType ?? .personal)
            sendBtn.isEnabled = false
            isTextViewEmpty = true
        }
    }
}

// MARK: - UITableViewDataSource
extension DefaultQuestionChatVC: UITableViewDataSource {
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionChatData.count
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: 서버통신시 userType별 수정가능 상태 조정 필요
        guard let questionCell = tableView.dequeueReusableCell(withIdentifier: ClassroomQuestionTVC.className) as? ClassroomQuestionTVC,
              let commentCell = tableView.dequeueReusableCell(withIdentifier: ClassroomCommentTVC.className) as? ClassroomCommentTVC,
              let questionEditCell = tableView.dequeueReusableCell(withIdentifier: ClassroomQuestionEditTVC.className) as? ClassroomQuestionEditTVC,
              let commentEditCell = tableView.dequeueReusableCell(withIdentifier: ClassroomCommentEditTVC.className) as? ClassroomCommentEditTVC else { return UITableViewCell() }
        
        if questionChatData[indexPath.row].writer.isQuestioner {
            if editIndex == [0,indexPath.row] {
                
                /// 1:1 질문자 답변 수정 셀
                questionEditCell.dynamicUpdateDelegate = self
                questionEditCell.bindData(questionChatData[indexPath.row])
                questionEditCell.tapConfirmBtnAction = { [unowned self] in
                    editIndex = []
                    requestEditPostComment(commentID: questionChatData[indexPath.row].messageID, content: questionEditCell.commentContentTextView.text)
                    editedCommentIndexPath = [IndexPath(row: indexPath.row, section: indexPath.section)]
                }
                
                questionEditCell.tapCancelBtnAction = { [unowned self] in
                    editIndex = []
                    defaultQuestionChatTV.reloadData()
                }
                return questionEditCell
            } else if questionChatData[indexPath.row].writer.isQuestioner {
                
                /// 1:1 질문자 질문원글 셀
                if indexPath.row == 0 {
                    questionCell.likeBtn.isHidden = false
                    questionCell.likeCountLabel.isHidden = false
                } else {
                    questionCell.likeBtn.isHidden = true
                    questionCell.likeCountLabel.isHidden = true
                }
                
                /// 1:1 질문자 셀 중 데이터가 삭제된 셀
                if questionChatData[indexPath.row].isDeleted {
                    [questionCell.titleLabelTopConstraint, questionCell.contentTextViewTopConstriaint].forEach {
                        $0?.constant = 0
                    }
                    [questionCell.majorLabel, questionCell.nicknameLabel, questionCell.moreBtn, questionCell.uploadDateLabel].forEach {
                        $0?.isHidden = true
                    }
                } else {
                    questionCell.titleLabelTopConstraint.constant = 16
                    questionCell.contentTextViewTopConstriaint.constant = 24
                    [questionCell.majorLabel, questionCell.nicknameLabel, questionCell.moreBtn, questionCell.uploadDateLabel].forEach {
                        $0?.isHidden = false
                    }
                }
                
                questionCell.dynamicUpdateDelegate = self
                questionCell.changeCellDelegate = self
                questionCell.tapMoreBtnAction = { [unowned self] in
                    
                    if questionType == .personal {
                        /// 1:1
                        if userType == 0 {
                            /// 작성자 본인
                            actionSheetString = returnActionSheetType(type: .editAndDelete)
                        } else if userType == 1{
                            /// 답변자 == 선배
                            actionSheetString = returnActionSheetType(type: .reportAndDelete)
                        } else {
                            /// 타인
                            actionSheetString = returnActionSheetType(type: .onlyReport)
                        }
                    } else {
                        /// 그룹
                        if userType == 0 {
                            /// 작성자 본인
                            actionSheetString = returnActionSheetType(type: .editAndDelete)
                        } else if userType == 1 {
                            /// 답변자
                            actionSheetString = returnActionSheetType(type: .onlyReport)
                        } else {
                            /// 타인
                            actionSheetString = returnActionSheetType(type: .onlyReport)
                        }
                    }
                    
                    if actionSheetString.count > 1 {
                        /// 작성자 본인이 흰색 말풍선의 더보기 버튼을 눌렀을 경우
                        self.makeTwoAlertWithCancel(okTitle: actionSheetString[0], secondOkTitle: actionSheetString[1], okAction: { _ in
                            if indexPath.row == 0 {
                                /// 수정
                                /// 질문 원글일 경우
                                let writeQuestionSB: UIStoryboard = UIStoryboard(name: Identifiers.WriteQusetionSB, bundle: nil)
                                guard let editPostVC = writeQuestionSB.instantiateViewController(identifier: WriteQuestionVC.className) as? WriteQuestionVC else { return }
                                
                                editPostVC.questionType = questionType ?? .personal
                                editPostVC.isEditState = true
                                editPostVC.postID = postID
                                editPostVC.originTitle = questionChatData[0].title
                                editPostVC.originContent = questionChatData[0].content
                                editPostVC.modalPresentationStyle = .fullScreen
                                
                                self.present(editPostVC, animated: true, completion: nil)
                            } else {
                                /// 질문 답변일 경우
                                editIndex = [0,indexPath.row]
                            }
                            defaultQuestionChatTV.reloadData()
                        }, secondOkAction: { _ in
                            /// 삭제
                            self.makeNadoDeleteAlert(qnaType: indexPath.row == 0 ? .question : .comment, commentID: questionChatData[indexPath.row].messageID, indexPath: [IndexPath(row: indexPath.row, section: indexPath.section)])
                        })
                    } else {
                        /// 타인이 흰색 말풍선의 더보기 버튼을 눌렀을 경우
                        self.makeAlertWithCancel(okTitle: actionSheetString[0], okAction: { _ in
                            self.reportActionSheet { reason in
                                requestReport(reportedTargetID: questionChatData[indexPath.row].messageID, reportedTargetTypeID: indexPath.row == 0 ? 2 : 3, reason: reason)
                            }
                        })
                    }
                    editIndex = []
                    moreBtnTapIndex = [0,indexPath.row]
                }
                questionCell.bindData(questionChatData[indexPath.row])
                questionCell.bindLikeData(questionLikeData ?? Like(isLiked: false, likeCount: 0))
                questionCell.tapLikeBtnAction = { [unowned self] in
                    requestPostClassroomLikeData(postID: postID ?? 0, postTypeID: self.questionType ?? .personal)
                }
                return questionCell
            }
        } else {
            if editIndex == [1,indexPath.row] {
                
                /// 답변자 답변 수정 셀
                commentEditCell.dynamicUpdateDelegate = self
                commentEditCell.changeCellDelegate = self
                commentEditCell.bindData(questionChatData[indexPath.row])
                commentEditCell.tapConfirmBtnAction = { [unowned self] in
                    editIndex = []
                    requestEditPostComment(commentID: questionChatData[indexPath.row].messageID, content: commentEditCell.commentContentTextView.text)
                    editedCommentIndexPath = [IndexPath(row: indexPath.row, section: indexPath.section)]
                }
                
                commentEditCell.tapCancelBtnAction = { [unowned self] in
                    editIndex = []
                    defaultQuestionChatTV.reloadData()
                }
                return commentEditCell
                
            } else {
                /// 1:1 답변자 셀
                
                /// 1:1 답변자 셀 중 데이터가 삭제된 셀
                if questionChatData[indexPath.row].isDeleted {
                    [commentCell.titleLabelTopConstraint, commentCell.contentTextViewTopConstriaint].forEach {
                        $0?.constant = 0
                    }
                    [commentCell.majorLabel, commentCell.nicknameLabel, commentCell.moreBtn, commentCell.uploadDateLabel].forEach {
                        $0?.isHidden = true
                    }
                } else {
                    commentCell.titleLabelTopConstraint.constant = 16
                    commentCell.contentTextViewTopConstriaint.constant = 24
                    [commentCell.majorLabel, commentCell.nicknameLabel, commentCell.moreBtn, commentCell.uploadDateLabel].forEach {
                        $0?.isHidden = false
                    }
                }
                
                commentCell.dynamicUpdateDelegate = self
                commentCell.changeCellDelegate = self
                commentCell.tapMoreBtnAction = { [unowned self] in
                    
                    if questionType == .personal {
                        /// 개인
                        if userType == 0 {
                            /// 1:1 -> 작성자 본인
                            actionSheetString = returnActionSheetType(type: .onlyReport)
                        } else if userType == 1 {
                            /// 1:1 -> 답변자
                            actionSheetString = returnActionSheetType(type: .editAndDelete)
                        } else {
                            /// 1:1 -> 타인
                            actionSheetString = returnActionSheetType(type: .onlyReport)
                        }
                    } else {
                        /// 그룹
                        if userType == 0 {
                            /// 그룹 -> 작성자 본인
                            actionSheetString = returnActionSheetType(type: .onlyReport)
                        } else {
                            /// 그룹 -> 답변자
                            if questionChatData[indexPath.row].writer.writerID == userID {
                                actionSheetString = returnActionSheetType(type: .editAndDelete)
                            } else {
                                actionSheetString = returnActionSheetType(type: .onlyReport)
                            }
                        }
                    }
                    
                    if actionSheetString.count > 1 {
                        /// 작성자 본인이 민트색 말풍선의 더보기 버튼을 눌렀을 경우
                        self.makeTwoAlertWithCancel(okTitle: actionSheetString[0], secondOkTitle: actionSheetString[1], okAction: { _ in
                            if actionSheetString[0] == "수정" {
                                editIndex = [1,indexPath.row]
                            }
                            defaultQuestionChatTV.reloadData()
                        }, secondOkAction: { _ in
                            self.makeNadoDeleteAlert(qnaType: indexPath.row == 0 ? .question : .comment, commentID: questionChatData[indexPath.row].messageID, indexPath: [IndexPath(row: indexPath.row, section: indexPath.section)])
                        })
                    } else {
                        /// 타인이 민트색 말풍선의 더보기 버튼을 눌렀을 경우
                        self.makeAlertWithCancel(okTitle: actionSheetString[0], okAction: { _ in
                            self.reportActionSheet { reason in
                                requestReport(reportedTargetID: questionChatData[indexPath.row].messageID, reportedTargetTypeID: 3, reason: reason)
                            }
                        })
                    }
                    editIndex = []
                    moreBtnTapIndex = [1,indexPath.row]
                }
                
                commentCell.bindData(questionChatData[indexPath.row])
                return commentCell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewCellDynamicUpdate
extension DefaultQuestionChatVC: TVCHeightDynamicUpdate {
    
    /// TextView의 높이를 동적으로 업데이트하는 메서드
    /// UITableViewCell 수정시 사용
    func updateTextViewHeight(cell: UITableViewCell, textView: UITextView) {
        let size = textView.bounds.size
        let newSize = defaultQuestionChatTV.sizeThatFits(CGSize(width: size.width,
                                                                height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            defaultQuestionChatTV.beginUpdates()
            defaultQuestionChatTV.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

// MARK: - TVCContentUpdate
extension DefaultQuestionChatVC: TVCContentUpdate {
    
    /// TableView의 내용 or UI를 업데이트하는 메서드
    func updateTV() {
        defaultQuestionChatTV.reloadData()
        if moreBtnTapIndex?.isEmpty == false {
            defaultQuestionChatTV.scrollToRow(at: IndexPath(row: moreBtnTapIndex?[1] ?? 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - Keyboard
extension DefaultQuestionChatVC {
    
    /// Keyboard Observer add 메서드
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            sendAreaTextViewBottom.constant = screenHeight == 667 ? keyboardSize.height + 6 : keyboardSize.height - 25
            sendBtnBottom.constant = screenHeight == 667 ? keyboardSize.height  + 1 : keyboardSize.height - 30

            let beginFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let endFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardShowUpY = (endFrame.origin.y - beginFrame.origin.y)
            self.defaultQuestionChatTV.contentOffset = CGPoint(x: 0, y: self.defaultQuestionChatTV.contentOffset.y - keyboardShowUpY)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            sendAreaTextViewBottom.constant = 5
            sendBtnBottom.constant = 0
            defaultQuestionChatTV.fitContentInset(inset: .zero)
        }
    }
    
    /// Keyboard Observer remove 메서드
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Network
extension DefaultQuestionChatVC {
    
    /// 1:1질문, 전체 질문, 정보글 상세 조회 API 요청 메서드
    private func requestGetDetailQuestionData(postID: Int) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.getQuestionDetailAPI(postID: postID) { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? ClassroomQuestionDetailData {
                    self.questionChatData = data.messageList
                    self.questionLikeData = data.like
                    self.userID = UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID)
                    self.userType = self.identifyUserType(questionerID: data.questionerID, answererID: data.answererID)
                    self.setUpSendBtnEnabledState(questionType: self.questionType ?? .personal, textView: self.sendAreaTextView)
                    
                    /// 댓글 수정되었을 때
                    if self.isCommentEdited {
                        self.defaultQuestionChatTV.performBatchUpdates {
                            self.defaultQuestionChatTV.reloadRows(at: self.editedCommentIndexPath, with: .automatic)
                        }
                        self.isCommentEdited = false
                    } else {
                        self.defaultQuestionChatTV.reloadData()
                    }
                    
                    /// 댓글 send되었을 때
                    if self.isCommentSend {
                        self.scrollTVtoBottom(animate: true)
                        self.isCommentSend = false
                    }
                    
                    self.configueTextViewPlaceholder(userType: self.userType ?? -1, questionType: self.questionType ?? .personal)
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
    private func requestCreateComment(postID: Int, comment: String) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.createCommentAPI(postID: postID, comment: comment) { networkResult in
            switch networkResult {
            case .success(let res):
                if let _ = res as? AddCommentData {
                    DispatchQueue.main.async {
                        self.requestGetDetailQuestionData(postID: postID)
                        self.isTextViewEmpty = true
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
    
    /// 전체 질문, 정보글 전체 목록에서 좋아요 API 요청 메서드
    private func requestPostClassroomLikeData(postID: Int, postTypeID: QuestionType) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.postClassroomLikeAPI(postID: postID, postTypeID: postTypeID.rawValue) { networkResult in
            switch networkResult {
            case .success(let res):
                if let _ = res as? PostLikeResModel {
                    self.requestGetDetailQuestionData(postID: self.postID ?? 0)
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
    
    /// 답변 수정 API 요청 메서드
    private func requestEditPostComment(commentID: Int, content: String) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.editPostCommentAPI(commentID: commentID, content: content) { networkResult in
            switch networkResult {
            case .success(_):
                self.isCommentEdited = true
                self.requestGetDetailQuestionData(postID: self.postID ?? 0)
                self.activityIndicator.stopAnimating()
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 1:1질문, 전체 질문 질문 원글 삭제 API 요청 메서드
    private func requestDeletePostQuestion(postID: Int) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.deletePostQuestionAPI(postID: postID) { networkResult in
            switch networkResult {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                self.activityIndicator.stopAnimating()
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 1:1질문, 전체 질문 질문 댓글 삭제 API 요청 메서드
    private func requestDeletePostComment(commentID: Int, indexPath: [IndexPath]) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.deletePostCommentAPI(commentID: commentID) { networkResult in
            switch networkResult {
            case .success(_):
                self.defaultQuestionChatTV.performBatchUpdates {
                    self.requestGetDetailQuestionData(postID: self.postID ?? 0)
                }
                self.activityIndicator.stopAnimating()
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 신고 API 요청 메서드
    private func requestReport(reportedTargetID: Int, reportedTargetTypeID: Int, reason: String) {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.requestReport(reportedTargetID: reportedTargetID, reportedTargetTypeID: reportedTargetTypeID, reason: reason) { networkResult in
            switch networkResult {
            case .success(_):
                self.makeAlert(title: "신고되었습니다.")
                self.activityIndicator.stopAnimating()
            case .requestErr(let msg):
                if let message = msg as? String {
                    self.makeAlert(title: message)
                }
                self.activityIndicator.stopAnimating()
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

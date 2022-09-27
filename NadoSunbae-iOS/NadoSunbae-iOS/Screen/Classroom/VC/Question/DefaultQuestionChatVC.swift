//
//  DefaultQuestionChatVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/10.
//

import UIKit
import FirebaseAnalytics
import SnapKit
import Then

enum UserType {
    case questioner
    case replier
    case other
}

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
            configueTextViewPlaceholder(userType: userType ?? .other)
            sendAreaTextView.sizeToFit()
        }
    }
    
    @IBOutlet var questionNaviBar: NadoSunbaeNaviBar!
    private let goToQuestionfloatingBtn = UIButton().then {
        $0.setImgByName(name: "goToQuestionFloating", selectedName: "goToQuestionFloating")
    }
    
    // MARK: Properties
    var naviStyle: NaviType?
    var postID: Int?
    var isAuthorized: Bool?
    private var userType: UserType?
    private var isBlocked: Bool?
    private var editIndex: [Int]?
    private var answererID: Int?
    private var questionData: DetailPost?
    private var questionerData: PostDetailWriter?
    private var commentData: [CommentList] = []
    private var questionLikeData: Like?
    private var isCommentEdited: Bool = false
    private var editedCommentIndexPath: [IndexPath] = []
    private var isCommentSend: Bool = false
    private var actionSheetString: [String] = []
    private var isTextViewEmpty: Bool = true
    private var sendTextViewLineCount: Int = 1
    private var keyboardShowUpY: CGFloat = 0
    private let textViewMaxHeight: CGFloat = 85
    private let userID: Int = UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID)
    
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
        addObserver()
        optionalBindingData()
        hideTabbar()
        makeScreenAnalyticsEvent(screenName: "ClassRoom_Question Tab", screenClass: DefaultQuestionChatVC.className)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    // MARK: IBAction
    @IBAction func tapSendBtn(_ sender: UIButton) {
        if !isTextViewEmpty {
            userType == .questioner ? leftSendAnimation(text: ".............") : rightSendAnimation(text: ".............")
            
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
    private func configueTextViewPlaceholder(userType: UserType) {
        sendAreaTextView.isEditable = (userType == .questioner || userType == .replier) ? true : false
        sendAreaTextView.text = (userType == .questioner || userType == .replier) ? "답글쓰기" : "다른 선배 개인 페이지에서는 답글 불가!"
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
                questionNaviBar.configureTitleLabel(title: "1:1 질문")
            case .present:
                questionNaviBar.setUpNaviStyle(state: .dismissWithCustomRightBtn)
                questionNaviBar.dismissBtn.press(vibrate: true, for: .touchUpInside) {
                    self.dismiss(animated: true, completion: nil)
                }
                questionNaviBar.configureTitleLabel(title: "1:1 질문")
            }
        }
    }
    
    /// 유저 유형을 식별하는 메서드
    private func identifyUserType(questionerID: Int, isAuthorized: Bool) -> UserType {
        if isAuthorized {
            return userID == questionerID ? .questioner : .replier
        } else {
            return .other
        }
    }
    
    /// 전송 버튼의 상태를 setUp하는 메서드
    private func setUpSendBtnEnabledState(textView: UITextView) {
        if isTextViewEmpty {
            sendBtn.isEnabled = false
        } else {
            sendBtn.isEnabled = userType == .other ? false : true
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
    
    /// 마이페이지로 뷰를 전환하는 메서드 (본인 마이페이지일 경우 탭 이동)
    private func goToMypageVC(userID: Int) {
        if userID == UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID) {
            goToRootOfTab(index: 3)
        } else {
            self.navigator?.instantiateVC(destinationViewControllerType: MypageUserVC.self, useStoryboard: true, storyboardName: MypageUserVC.className, naviType: .push) { mypageUserVC in
                mypageUserVC.targetUserID = userID
                mypageUserVC.judgeBlockStatusDelegate = self
            }
        }
    }
    
    /// 알림탭 메인으로 뷰를 전환하는 메서드
    @objc
    private func goToNotificationVC() {
        goToRootOfTab(index: 2)
    }
}

// MARK: - Congifure Cell Methods
extension DefaultQuestionChatVC {
    
    /// 질문 작성자의 "더보기" 버튼 클릭시 액션을 설정하는 메서드
    private func setQuestionerMoreBtnAction(_ indexPath: IndexPath) {
        if self.actionSheetString.count > 1 {
            /// 작성자 본인이 흰색 말풍선의 더보기 버튼을 눌렀을 경우
            self.makeTwoAlertWithCancel(okTitle: self.actionSheetString[0], secondOkTitle: self.actionSheetString[1], okAction: { [weak self] _ in
                guard let self = self else { return }
                
                if indexPath.section == 0 {
                    /// 수정
                    /// 질문 원글일 경우
                    self.navigator?.instantiateVC(destinationViewControllerType: WriteQuestionVC.self, useStoryboard: true, storyboardName: Identifiers.WriteQusetionSB, naviType: .present, modalPresentationStyle: .fullScreen) { [weak self] writeQuestionVC in
                        writeQuestionVC.questionType = .questionToPerson
                        writeQuestionVC.isEditState = true
                        writeQuestionVC.postID = self?.postID
                        writeQuestionVC.originTitle = self?.questionData?.title
                        writeQuestionVC.originContent = self?.questionData?.content
                    }
                } else {
                    /// 질문 답변일 경우
                    self.dismissKeyboard()
                    self.editIndex = [1, indexPath.row]
                }
                self.defaultQuestionChatTV.reloadData()
            }, secondOkAction: { [weak self] _ in
                guard let self = self else { return }
                /// 삭제
                self.makeNadoDeleteAlert(qnaType: indexPath.row == 0 ? .question : .comment, commentID: indexPath.row == 0 ? self.questionData?.postDetailID ?? 0 : self.commentData[indexPath.row].commentID, indexPath: [IndexPath(row: indexPath.row, section: indexPath.section)])
            })
        } else {
            /// 타인이 흰색 말풍선의 더보기 버튼을 눌렀을 경우
            self.makeAlertWithCancel(okTitle: self.actionSheetString[0], okAction: { [weak self] _ in
                self?.reportActionSheet { [weak self] reason in
                    guard let self = self else { return }
                    self.requestReport(reportedTargetID: indexPath.row == 0 ? self.questionData?.postDetailID ?? 0 : self.commentData[indexPath.row].commentID, reportedTargetTypeID: indexPath.row == 0 ? 2 : 3, reason: reason)
                }
            })
        }
    }
    
    /// 각 셀의 "더보기" 버튼 클릭시 액션을 설정하는 메서드
    private func setMoreBtnAction(_ type: QnAType, _ indexPath: IndexPath) {
        if self.actionSheetString.count > 1 {
            /// 작성자 본인이 말풍선의 더보기 버튼을 눌렀을 경우
            self.makeTwoAlertWithCancel(okTitle: self.actionSheetString[0], secondOkTitle: self.actionSheetString[1], okAction: { [weak self] _ in
                guard let self = self else { return }
                
                switch type {
                case .question:
                    if indexPath.section == 0 {
                        if self.actionSheetString[0] == "수정" {
                            /// 수정
                            /// 질문 원글일 경우
                            self.navigator?.instantiateVC(destinationViewControllerType: WriteQuestionVC.self, useStoryboard: true, storyboardName: Identifiers.WriteQusetionSB, naviType: .present, modalPresentationStyle: .fullScreen) { [weak self] writeQuestionVC in
                                writeQuestionVC.questionType = .questionToPerson
                                writeQuestionVC.isEditState = true
                                writeQuestionVC.postID = self?.postID
                                writeQuestionVC.originTitle = self?.questionData?.title
                                writeQuestionVC.originContent = self?.questionData?.content
                            }
                        } else {
                            self.reportActionSheet { [weak self] reason in
                                guard let self = self else { return }
                                self.requestReport(reportedTargetID: indexPath.section == 0 ? self.questionData?.postDetailID ?? 0 : self.commentData[indexPath.row].commentID, reportedTargetTypeID: indexPath.section == 0 ? 2 : 3, reason: reason)
                            }
                        }
                    } else {
                        /// 질문 답변일 경우
                        self.dismissKeyboard()
                        self.editIndex = [0, indexPath.row]
                    }
                case .comment:
                    if self.actionSheetString[0] == "수정" {
                        self.dismissKeyboard()
                        self.editIndex = [1, indexPath.row]
                    }
                }
                
                self.defaultQuestionChatTV.reloadData()
            }, secondOkAction: { [weak self] _ in
                guard let self = self else { return }
                /// 삭제
                self.makeNadoDeleteAlert(qnaType: indexPath.section == 0 ? .question : .comment, commentID: indexPath.section == 0 ? self.questionData?.postDetailID ?? 0 : self.commentData[indexPath.row].commentID, indexPath: [IndexPath(row: indexPath.row, section: indexPath.section)])
            })
        } else {
            /// 타인이 말풍선의 더보기 버튼을 눌렀을 경우
            self.makeAlertWithCancel(okTitle: self.actionSheetString[0], okAction: { [weak self] _ in
                self?.reportActionSheet { [weak self] reason in
                    guard let self = self else { return }
                    self.requestReport(reportedTargetID: indexPath.section == 0 ? self.questionData?.postDetailID ?? 0 : self.commentData[indexPath.row].commentID, reportedTargetTypeID: indexPath.section == 0 ? 2 : 3, reason: reason)
                }
            })
        }
        
        self.editIndex = []
    }
    
    /// 질문 Cell을 구성하는 메서드
    private func configureQuestionCell(indexPath: IndexPath, questionCell: ClassroomQuestionTVC) {
        if let questionerData = questionerData {
            questionCell.bindWriterData(indexPath.section == 0 ? questionerData : commentData[indexPath.row].writer)
        }
        questionCell.bindLikeData(questionLikeData ?? Like(isLiked: false, likeCount: 0))
        
        questionCell.dynamicUpdateDelegate = self
        
        questionCell.tapLikeBtnAction = { [weak self] in
            // ✅ TODO: 좋아요 API 변경 후 작업
            //            requestPostClassroomLikeData(postID: postID ?? 0, postTypeID: self.questionType ?? .personal)
        }
        
        questionCell.tapNicknameBtnAction = { [weak self] in
            self?.goToMypageVC(userID: indexPath.row == 0 ? self?.questionerData?.writerID ?? 0 : self?.commentData[indexPath.row].writer.writerID ?? 0)
        }
        
        questionCell.interactURL = { url in
            self.presentToSafariVC(url: url)
        }
        
        questionCell.tapMoreBtnAction = { [weak self] in
            guard let self = self else { return }
            self.actionSheetString = self.setActionSheetString(.question)
            self.setMoreBtnAction(.question, indexPath)
        }
        
        if indexPath.section == 0 {
            questionCell.likeBtn.isHidden = false
            questionCell.likeCountLabel.isHidden = false
            questionCell.titleLabelTopConstraint.constant = 16
            questionCell.moreBtnTopConstraint.constant = 20
        } else {
            questionCell.likeBtn.isHidden = true
            questionCell.likeCountLabel.isHidden = true
            questionCell.titleLabelTopConstraint.constant = 12
            questionCell.moreBtnTopConstraint.constant = 16
        }
    }
    
    /// 댓글 Cell을 구성하는 메서드
    private func configureCommentCell(_ indexPath: IndexPath, _ commentCell: ClassroomCommentTVC) {
        commentCell.dynamicUpdateDelegate = self
        commentCell.tapMoreBtnAction = { [weak self] in
            guard let self = self else { return }
            self.actionSheetString = self.setActionSheetString(.comment)
            self.setMoreBtnAction(.comment, indexPath)
        }
        
        commentCell.tapNicknameBtnAction = { [weak self] in
            guard let self = self else { return }
            self.goToMypageVC(userID: self.commentData[indexPath.row].writer.writerID)
        }
        
        commentCell.interactURL = { [weak self] url in
            self?.presentToSafariVC(url: url)
        }
    }
    
    /// 1:1 답변자 셀 중 데이터가 삭제된 셀을 구성하는 메서드
    private func configureDeletedCommentCell(_ indexPath: IndexPath, _ commentCell: ClassroomCommentTVC) {
        if commentData[indexPath.row].isDeleted {
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
    }
    
    /// 1:1 질문자 셀 중 데이터가 삭제된 셀을 구성하는 메서드
    private func configureDeletedQuestionCell(_ indexPath: IndexPath, _ questionCell: ClassroomQuestionTVC) {
        if indexPath.section == 1 {
            if commentData[indexPath.row].isDeleted {
                    [questionCell.titleLabelTopConstraint, questionCell.contentTextViewTopConstriaint].forEach {
                        $0?.constant = 0
                    }
                    [questionCell.majorLabel, questionCell.nicknameLabel, questionCell.moreBtn, questionCell.uploadDateLabel].forEach {
                        $0?.isHidden = true
                    }
            } else {
                questionCell.contentTextViewTopConstriaint.constant = 24
                [questionCell.majorLabel, questionCell.nicknameLabel, questionCell.moreBtn, questionCell.uploadDateLabel].forEach {
                    $0?.isHidden = false
                }
            }
        } else {
            // Cell 재사용 문제를 피하기 위한 예외처리
            questionCell.titleLabelTopConstraint.constant = 16
            questionCell.contentTextViewTopConstriaint.constant = 24
            [questionCell.majorLabel, questionCell.nicknameLabel, questionCell.moreBtn, questionCell.uploadDateLabel].forEach {
                $0?.isHidden = false
            }
        }
    }
    
    /// 1:1 질문자 답변 수정 셀 구성 메서드
    private func configureEditQuestionCell(_ indexPath: IndexPath, _ questionEditCell: ClassroomQuestionEditTVC) {
        questionEditCell.dynamicUpdateDelegate = self
        questionEditCell.bindData(commentData[indexPath.row])
        questionEditCell.tapConfirmBtnAction = { [unowned self] in
            editIndex = []
            requestEditPostComment(commentID: commentData[indexPath.row].commentID, content: questionEditCell.commentContentTextView.text)
            editedCommentIndexPath = [IndexPath(row: indexPath.row, section: indexPath.section)]
        }
        
        questionEditCell.tapCancelBtnAction = { [unowned self] in
            editIndex = []
            defaultQuestionChatTV.reloadData()
        }
    }
    
    /// 1:1 질문자 답변 수정 셀 구성 메서드
    private func configureEditCommentCell(_ indexPath: IndexPath, _ commentEditCell: ClassroomCommentEditTVC) {
        commentEditCell.dynamicUpdateDelegate = self
        commentEditCell.bindData(commentData[indexPath.row])
        commentEditCell.tapConfirmBtnAction = { [unowned self] in
            editIndex = []
            requestEditPostComment(commentID: commentData[indexPath.row].commentID, content: commentEditCell.commentContentTextView.text)
            editedCommentIndexPath = [IndexPath(row: indexPath.row, section: indexPath.section)]
        }
        
        commentEditCell.tapCancelBtnAction = { [unowned self] in
            editIndex = []
            defaultQuestionChatTV.reloadData()
        }
    }
    
    /// QuestionCellType, UserType에 따라 더보기 클릭시 나타나는 ActionSheet의 String을 설정하는 메서드
    private func setActionSheetString(_ cellType: QnAType) -> [String] {
        if userType == .questioner {
            /// 작성자 본인
            return returnActionSheetType(type: cellType == .question ? .editAndDelete : .onlyReport)
        } else if userType == .replier {
            /// 답변자 == 선배
            return returnActionSheetType(type: cellType == .question ? .reportAndDelete : .editAndDelete)
        } else {
            /// 타인
            return returnActionSheetType(type: .onlyReport)
        }
    }
}

// MARK: - Observer
extension DefaultQuestionChatVC {
    
    /// Observer add 메서드
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToNotificationVC), name: Notification.Name.pushNotificationClicked, object: nil)
    }
    
    /// Observer remove 메서드
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.pushNotificationClicked, object: nil)
    }
}

// MARK: - UITextViewDelegate
extension DefaultQuestionChatVC: UITextViewDelegate {
    
    /// textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        sendAreaDynamicHeight(textView: textView)
        adjustTVContentOffset(textView: textView)
        isTextViewEmpty = textView.text.isEmpty ? true : false
        setUpSendBtnEnabledState(textView: sendAreaTextView)
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
            configueTextViewPlaceholder(userType: userType ?? .other)
            sendBtn.isEnabled = false
            isTextViewEmpty = true
        }
    }
}

// MARK: - UITableViewDataSource
extension DefaultQuestionChatVC: UITableViewDataSource {
    
    /// numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return questionData != nil ? 1 : 0
        case 1:
            return commentData.count
        default:
            return 0
        }
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let questionCell = tableView.dequeueReusableCell(withIdentifier: ClassroomQuestionTVC.className) as? ClassroomQuestionTVC,
              let commentCell = tableView.dequeueReusableCell(withIdentifier: ClassroomCommentTVC.className) as? ClassroomCommentTVC,
              let questionEditCell = tableView.dequeueReusableCell(withIdentifier: ClassroomQuestionEditTVC.className) as? ClassroomQuestionEditTVC,
              let commentEditCell = tableView.dequeueReusableCell(withIdentifier: ClassroomCommentEditTVC.className) as? ClassroomCommentEditTVC else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            // 질문 원글
            if let questionData = questionData {
                questionCell.bindQuestionData(questionData)
            } else {
                questionCell.bindQuestionData(DetailPost(postDetailID: 0, title: "", content: "", createdAt: "", majorName: ""))
            }
            configureDeletedQuestionCell(indexPath, questionCell)
            configureQuestionCell(indexPath: indexPath, questionCell: questionCell)
            return questionCell
        case 1:
            // 답변글 중 질문자의 글
            if questionerData?.writerID == commentData[indexPath.row].writer.writerID {
                if editIndex == [0, indexPath.row] {
                    configureEditQuestionCell(indexPath, questionEditCell)
                    return questionEditCell
                }
                questionCell.bindCommentData(commentData[indexPath.row])
                configureDeletedQuestionCell(indexPath, questionCell)
                configureQuestionCell(indexPath: indexPath, questionCell: questionCell)
                return questionCell
            } else {
                // 답변글 중 답변자의 글
                if editIndex == [1, indexPath.row] {
                    configureEditCommentCell(indexPath, commentEditCell)
                    return commentEditCell
                }
                commentCell.bindData(commentData[indexPath.row])
                configureCommentCell(indexPath, commentCell)
                configureDeletedCommentCell(indexPath, commentCell)
                return commentCell
            }
        default:
            return UITableViewCell()
        }
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

// MARK: - SendBlockedInfoDelegate
extension DefaultQuestionChatVC: SendBlockedInfoDelegate {
    func sendBlockedInfo(status: Bool, userID: Int) {
        if questionerData?.writerID == userID {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - Keyboard
extension DefaultQuestionChatVC {
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            sendAreaTextViewBottom.constant = screenHeight == 667 ? keyboardSize.height + 6 : keyboardSize.height - 25
            sendBtnBottom.constant = screenHeight == 667 ? keyboardSize.height  + 1 : keyboardSize.height - 30
            
            let beginFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let endFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            guard !beginFrame.equalTo(endFrame) else {
                return
            }
            
            keyboardShowUpY = (endFrame.origin.y - beginFrame.origin.y)
            self.defaultQuestionChatTV.contentOffset = CGPoint(x: 0, y: self.defaultQuestionChatTV.contentOffset.y - keyboardShowUpY)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            sendAreaTextViewBottom.constant = 5
            sendBtnBottom.constant = 0
            self.defaultQuestionChatTV.contentOffset = CGPoint(x: 0, y: self.defaultQuestionChatTV.contentOffset.y + keyboardShowUpY)
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Network
extension DefaultQuestionChatVC {
    
    /// 1:1질문, 전체 질문, 정보글 상세 조회 API 요청 메서드
    private func requestGetDetailQuestionData(postID: Int) {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.getPostDetail(postID: postID) { [weak self] networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? PostDetailResModel {
                    guard let self = self else { return }
                    self.questionData = data.post
                    self.commentData = data.commentList
                    self.questionLikeData = data.like
                    self.questionerData = data.writer
                    self.userType = self.identifyUserType(questionerID: data.writer.writerID, isAuthorized: data.isAuthorized)
                    self.setUpSendBtnEnabledState(textView: self.sendAreaTextView ?? UITextView())
                    
                    /// 댓글 수정되었을 때
                    if self.isCommentEdited == true {
                        self.defaultQuestionChatTV.performBatchUpdates {
                            self.dismissKeyboard()
                            self.defaultQuestionChatTV.reloadRows(at: self.editedCommentIndexPath, with: .automatic)
                        }
                        self.isCommentEdited = false
                    } else {
                        self.defaultQuestionChatTV.reloadData()
                    }
                    
                    /// 댓글 send되었을 때
                    if self.isCommentSend == true {
                        self.scrollTVtoBottom(animate: true)
                        self.isCommentSend = false
                    }
                    
                    self.configueTextViewPlaceholder(userType: self.userType ?? .other)
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self?.activityIndicator.stopAnimating()
                    self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self?.updateAccessToken { _ in
                        self?.optionalBindingData()
                    }
                } else if res is Int {
                    self?.activityIndicator.stopAnimating()
                    self?.makeAlert(title: "삭제된 게시글입니다.") { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            default:
                self?.activityIndicator.stopAnimating()
                self?.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
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
                    FirebaseAnalytics.Analytics.logEvent("user_question", parameters: [
                        "question_type": "question_reply",
                        "UserID": UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID),
                        "FirstMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? "",
                        "SecondMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) ?? ""
                    ])
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.requestCreateComment(postID: self.postID ?? 0, comment: self.sendAreaTextView.text)
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 전체 질문, 정보글 전체 목록에서 좋아요 API 요청 메서드
    // TODO: 좋아요 API 다시 연결하기
    //    private func requestPostClassroomLikeData(postID: Int, postTypeID: QuestionType) {
    //        self.activityIndicator.startAnimating()
    //        ClassroomAPI.shared.postClassroomLikeAPI(postID: postID, postTypeID: postTypeID.rawValue) { networkResult in
    //            switch networkResult {
    //            case .success(let res):
    //                if let _ = res as? PostLikeResModel {
    //                    self.requestGetDetailQuestionData(postID: self.postID ?? 0)
    //                    self.activityIndicator.stopAnimating()
    //                }
    //            case .requestErr(let res):
    //                if let message = res as? String {
    //                    print(message)
    //                    self.activityIndicator.stopAnimating()
    //                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
    //                } else if res is Bool {
    //                    self.updateAccessToken { _ in
    //                        self.requestPostClassroomLikeData(postID: self.postID ?? 0, postTypeID: self.questionType ?? .personal)
    //                    }
    //                }
    //            default:
    //                self.activityIndicator.stopAnimating()
    //                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
    //            }
    //        }
    //    }
    
    /// 답변 수정 API 요청 메서드
    private func requestEditPostComment(commentID: Int, content: String) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.editPostCommentAPI(commentID: commentID, content: content) { networkResult in
            switch networkResult {
            case .success(_):
                self.isCommentEdited = true
                self.requestGetDetailQuestionData(postID: self.postID ?? 0)
                self.activityIndicator.stopAnimating()
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.activityIndicator.stopAnimating()
                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    }
                }
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
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.requestDeletePostQuestion(postID: self.postID ?? 0)
                    }
                }
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
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.activityIndicator.stopAnimating()
                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

//
//  DefaultQuestionChatVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/10.
//

import UIKit

class DefaultQuestionChatVC: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet var sendAreaTextViewHeight: NSLayoutConstraint!
    @IBOutlet var animateTop: NSLayoutConstraint!
    @IBOutlet var animationLeading: NSLayoutConstraint!
    @IBOutlet var animateTrailing: NSLayoutConstraint!
    @IBOutlet var animationWidth: NSLayoutConstraint!
    @IBOutlet var defaultQuestionChatTV: UITableView! {
        didSet {
            defaultQuestionChatTV.dataSource = self
            defaultQuestionChatTV.allowsSelection = false
            defaultQuestionChatTV.separatorStyle = .none
            defaultQuestionChatTV.rowHeight  = UITableView.automaticDimension
            scrollTVtoBottom(animate: false)
        }
    }
    
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
            sendAreaTextView.textColor = .gray2
            sendAreaTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 15)
            sendAreaTextView.sizeToFit()
        }
    }
    
    // MARK: Properties
    var editIndex: [Int]?
    let textViewMaxHeight: CGFloat = 85
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        sendAreaTextView.centerVertically()
    }
    
    // MARK: Custom Methods
    /// TableView에 Xib 등록하는 메서드
    private func registerXib() {
        ClassroomQuestionTVC.register(target: defaultQuestionChatTV)
        ClassroomCommentTVC.register(target: defaultQuestionChatTV)
        ClassroomQuestionEditTVC.register(target: defaultQuestionChatTV)
        ClassroomCommentEditTVC.register(target: defaultQuestionChatTV)
    }
    
    // MARK: IBAction
    @IBAction func tapSendBtn(_ sender: UIButton) {
        // TODO: 서버 연결 후 더미데이터 삭제할 예정입니다!
        defaultQuestionData.append(contentsOf: [DefaultQuestionDataModel(isWriter: false, questionTitle: "제목은너무졸려서패쓰요", nickname: "지으니", majorInfo: "디미과", contentText: sendAreaTextView.text)])
        rightSendAnimation(text: ".............")
        DispatchQueue.main.async {
            self.defaultQuestionChatTV.reloadData()
        }
    }
}

// MARK: - UI
extension DefaultQuestionChatVC {
    
    /// 메시지 보내기: 기본 애니메이션 동작 메서드
    func bubbleAnimation(_ duration: TimeInterval, _ topConstraint: CGFloat, _ widthConstraint: CGFloat, _ trailingConstraint: CGFloat , _ backgroundColor: UIColor, _ finishedTopConstraint: CGFloat, _ finishedTrailingConstraint: CGFloat, _ finishedWidthConstraint: CGFloat, _ finishedLeadingConstraint: CGFloat, _ finishedBackgroundColor: UIColor) {
        UIView.animate(withDuration: duration, animations: {
            self.animationLabel.isHidden = false
            self.animateTop.constant = topConstraint
            self.animationWidth.constant = widthConstraint
            self.animateTrailing.constant = trailingConstraint
            self.animationLabel.backgroundColor = backgroundColor
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.animationLabel.isHidden = true
            self.animateTop.constant = finishedTopConstraint
            self.animateTrailing.constant = finishedTrailingConstraint
            self.animationWidth.constant = finishedWidthConstraint
            self.animationLeading.constant = finishedLeadingConstraint
            self.animationLabel.backgroundColor = finishedBackgroundColor
            self.defaultQuestionChatTV.reloadData()
            self.scrollTVtoBottom(animate: true)
        })
    }
    
    /// 메시지 보내기: 기본 애니메이션 확장 -> 오른쪽 버블 애니메이션 메서드 (constraint 조정)
    func rightSendAnimation(text: String) {
        var constraint: CGFloat = 0, animateConstraint: CGFloat = 0
        animationLabel.text = text
        animationLabel.numberOfLines = 0
        animateTop.constant = self.view.frame.height - animationLabel.frame.height
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
    
    ///  TableView 최하단으로 scroll하는 메서드
    func scrollTVtoBottom(animate: Bool) {
        DispatchQueue.main.async {
            let lastSectionIndex = self.defaultQuestionChatTV!.numberOfSections - 1
            let lastRowIndex = self.defaultQuestionChatTV.numberOfRows(inSection: lastSectionIndex) - 1
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            self.defaultQuestionChatTV.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.none, animated: animate)
        }
    }
}

// MARK: - UITextViewDelegate
extension DefaultQuestionChatVC: UITextViewDelegate {
    
    /// textViewDidChange
    func textViewDidChange(_ textView: UITextView) {
        
        /// 텍스트 줄이 변경될 때마다 TableView를 bottom으로 animate
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: defaultQuestionData.count-1, section: 0)
            self.defaultQuestionChatTV.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        
        if textView.contentSize.height >= self.textViewMaxHeight {
            sendAreaTextViewHeight.constant = self.textViewMaxHeight
            textView.isScrollEnabled = true
        } else {
            sendAreaTextViewHeight.constant = textView.contentSize.height
            textView.isScrollEnabled = false
        }
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
            // TODO: 유저 정보에 따라 분기처리 필요
            textView.text = "답글쓰기"
            textView.textColor = .gray2
        }
    }
}


// MARK: - UITableViewDataSource
extension DefaultQuestionChatVC: UITableViewDataSource {
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultQuestionData.count
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let questionCell = tableView.dequeueReusableCell(withIdentifier: ClassroomQuestionTVC.className) as? ClassroomQuestionTVC,
              let commentCell = tableView.dequeueReusableCell(withIdentifier: ClassroomCommentTVC.className) as? ClassroomCommentTVC,
              let questionEditCell = tableView.dequeueReusableCell(withIdentifier: ClassroomQuestionEditTVC.className) as? ClassroomQuestionEditTVC,
              let commentEditCell = tableView.dequeueReusableCell(withIdentifier: ClassroomCommentEditTVC.className) as? ClassroomCommentEditTVC else { return UITableViewCell() }
        
        if editIndex == [0, indexPath.row] {
            
            /// 1:1 질문자 답변 수정 셀
            questionEditCell.dynamicUpdateDelegate = self
            questionEditCell.bind(defaultQuestionData[indexPath.row])
            return questionEditCell
            
        } else if editIndex == [1, indexPath.row] {
            
            /// 1:1 답변자 답변 수정 셀
            commentEditCell.dynamicUpdateDelegate = self
            commentEditCell.changeCellDelegate = self
            commentEditCell.bind(defaultQuestionData[indexPath.row])
            return commentEditCell
            
        } else if defaultQuestionData[indexPath.row].isWriter == true {
            
            /// 1:1 질문자 셀
            if indexPath.row == 0 {
                // TODO: 질문 원글은 추후에 수정을 해당 view가 아니라 질문작성뷰에서 처리하도록 기능을 붙여나갈 예정임
                questionCell.moreBtn.isEnabled = false
            } else {
                questionCell.moreBtn.isEnabled = true
            }
            questionCell.dynamicUpdateDelegate = self
            questionCell.changeCellDelegate = self
            questionCell.tapMoreBtnAction = { [unowned self] in
                editIndex = [0, indexPath.row]
            }
            questionCell.bind(defaultQuestionData[indexPath.row])
            return questionCell
            
        } else {
            
            /// 1:1 답변자 셀
            commentCell.dynamicUpdateDelegate = self
            commentCell.changeCellDelegate = self
            commentCell.tapMoreBtnAction = { [unowned self] in
                editIndex = [1, indexPath.row]
            }
            commentCell.bind(defaultQuestionData[indexPath.row])
            return commentCell
        }
    }
}

// MARK: - UITableViewCellDynamicUpdate
extension DefaultQuestionChatVC: TVCHeightDynamicUpdate {
    
    /// TextView의 높이를 동적으로 업데이트하는 메서드
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
        defaultQuestionChatTV.scrollToRow(at: IndexPath(row: editIndex?[1] ?? 0, section: 0), at: .top, animated: true)
    }
}

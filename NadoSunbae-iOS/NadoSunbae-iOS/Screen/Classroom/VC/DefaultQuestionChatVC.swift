//
//  DefaultQuestionChatVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/10.
//

import UIKit

class DefaultQuestionChatVC: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet var defaultQuestionChatTV: UITableView! {
        didSet {
            defaultQuestionChatTV.dataSource = self
            defaultQuestionChatTV.allowsSelection = false
            defaultQuestionChatTV.separatorStyle = .none
            defaultQuestionChatTV.rowHeight  = UITableView.automaticDimension
        }
    }
    
    // MARK: Properties
    var editIndex: [Int]?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    // MARK: Custom Methods
    /// TableView에 Xib 등록하는 메서드
    private func registerXib() {
        ClassroomQuestionTVC.register(target: defaultQuestionChatTV)
        ClassroomCommentTVC.register(target: defaultQuestionChatTV)
        ClassroomQuestionEditTVC.register(target: defaultQuestionChatTV)
        ClassroomCommentEditTVC.register(target: defaultQuestionChatTV)
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
                // TODO: - 질문 원글은 추후에 수정을 해당 view가 아니라 질문작성뷰에서 처리하도록 기능을 붙여나갈 예정임
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
    
    /// textView의 높이를 동적으로 업데이트하는 메서드
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

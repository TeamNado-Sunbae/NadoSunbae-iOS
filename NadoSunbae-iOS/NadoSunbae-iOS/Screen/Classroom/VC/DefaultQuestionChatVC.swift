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
              let commentCell = tableView.dequeueReusableCell(withIdentifier: ClassroomCommentTVC.className) as? ClassroomCommentTVC else { return UITableViewCell() }
        
        if defaultQuestionData[indexPath.row].isWriter == true {
            questionCell.dynamicUpdateDelegate = self
            questionCell.bind(defaultQuestionData[indexPath.row])
            return questionCell
        } else {
            commentCell.dynamicUpdateDelegate = self
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
            UIView.setAnimationsEnabled(true)        }
    }
}

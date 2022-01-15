//
//  UITableView+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

extension UITableView {
    
    /// TableView 하단 빈 셀 없애는 메서드
    func setBottomEmptyView() {
        let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableFooterView = dummyView
    }
    
    func fitContentInset(inset: UIEdgeInsets!) {
        self.contentInset = inset
        self.scrollIndicatorInsets = inset
    }
}

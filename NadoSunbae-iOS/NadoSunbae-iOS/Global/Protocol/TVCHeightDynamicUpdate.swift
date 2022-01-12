//
//  TVCHeightDynamicUpdate.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/10.
//

import UIKit

protocol TVCHeightDynamicUpdate: AnyObject {
    
    /// textView의 높이를 Update하는 메셔드
    func updateTextViewHeight(cell: UITableViewCell, textView: UITextView)
}

//
//  BaseTVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/11.
//

import UIKit

class BaseTVC: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// 마지막 셀의 separator를 제거하는 함수, cellForRowAt에서 호출한다.
    func removeBottomSeparator(isLast: Bool) {
        if isLast {
            self.addAboveTheBottomBorderWithColor()
        } else {
            if self.layer.sublayers?.last?.bounds.height == 1 {
                self.layer.sublayers?.last?.removeFromSuperlayer()
            }
        }
    }
}

// MARK: - TVRegisterable
extension BaseTVC: TVRegisterable {
    
    static var isFromNib: Bool {
        get {
            return true
        }
    }
}

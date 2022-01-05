//
//  UITableViewCell+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

extension UITableViewCell {
    
    /// TableViewCell tap 시 백그라운드 색이 변하지 않게 하는 메서드
    func setNoBackgroundForSelected() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }
}

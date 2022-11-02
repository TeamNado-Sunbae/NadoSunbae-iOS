//
//  BaseTVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/11.
//

import UIKit
import FirebaseAnalytics

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
    
    /// Firebase Analytics 기본 이벤트 메서드
    func makeAnalyticsEvent(eventName: GAEventNameType, parameterValue: String) {
        // TODO: 배포 전 주석 제거
//        if env() == .production {
            let parameterName = eventName.hasParameter ? eventName.parameterName : nil
            
            if let parameterName = parameterName {
                FirebaseAnalytics.Analytics.logEvent("\(eventName)", parameters: [parameterName : parameterValue])
            } else {
                FirebaseAnalytics.Analytics.logEvent("\(eventName)", parameters: nil)
            }
//        }
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

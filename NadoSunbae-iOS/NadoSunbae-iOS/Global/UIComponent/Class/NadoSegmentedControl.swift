//
//  NadoSegmentedControl.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/07/14.
//

import UIKit
import Then

/**
 - Description:
 나도선배 Style의 SegmentedControl
 bg: .segmentBgColor / font: .gray3
 selected bg: white / selected font: .mainDefault(mint)
 폰트는 Pretendard-SemiBold: 14pt가 기본이고 이외에는 메서드를 통해 커스텀하여 사용
 
 - Note:
 - setBackgroundColor: SegmentControl Background 색 변경
 - setSegmentItems: Segment가 될 Item들 설정 [String]
 */

final class NadoSegmentedControl: UISegmentedControl {
    
    // MARK: init
    init(items: [String]) {
        super.init(frame: .zero)
        configureDefaultStyle()
        setSegmentItems(items: items)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureDefaultStyle()
    }
    
    // MARK: layoutSubViews
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSelectedSegmentStyle(index: numberOfSegments)
        
        for i in 0...(numberOfSegments - 1)  {
            subviews[i].isHidden = true
        }
    }
}

// MARK: - UI
extension NadoSegmentedControl {
    
    /// NadoSegmentedControl의 기본 UI Style을 구성하는 메서드
    private func configureDefaultStyle() {
        backgroundColor = .segmentBgColor
        selectedSegmentTintColor = .white
        setDefaultTextStyle()
        setSelectedTextStyle()
        removeDivider()
    }
    
    /// NadoSegmentedControl의 item간 divider를 제거하는 메서드
    private func removeDivider() {
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    /// NadoSegmentedControl의 backgroundColor를 변경하는 메서드
    func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
    
    /** NadoSegmentedControl의 기본 Text Style을 구성하는 메서드
     - Note:
     - Default: Font - PretendardSB 14.0 / Color: mainDefault
     - Default Style 이외: 파라미터 값 변경하여 사용
     */
    func setDefaultTextStyle(font: UIFont = UIFont.PretendardR(size: 14.0), color: UIColor = UIColor.gray3) {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    /** NadoSegmentedControl의 선택된 Text Style을 구성하는 메서드
     - Note:
     - Default: Font - PretendardSB 14.0 / Color: mainDefault
     - Default Style 이외: 파라미터 값 변경하여 사용
     */
    func setSelectedTextStyle(font: UIFont = UIFont.PretendardSB(size: 14.0), color: UIColor = UIColor.mainDefault) {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    /// 세그먼트가 선택되었을 때 강조되는 뷰를 찾아 Style을 커스텀하는 메서드
    private func configureSelectedSegmentStyle(index itemCount: Int) {
        if let imageView = subviews[itemCount] as? UIImageView {
            imageView.makeRounded(cornerRadius: 6)
            
            let originFrame = imageView.frame
            imageView.layer.frame = CGRect(x: originFrame.minX + 2, y: originFrame.minY + 2, width: originFrame.width - 4, height: originFrame.height - 4)
            imageView.layer.shadowColor = nil
            imageView.layer.shadowPath = .none
            imageView.layer.shadowOffset = .zero
            
            // Bounds를 업데이트할 때 발생하는 animation인 "SelectionBounds"을 제거
            imageView.layer.removeAnimation(forKey: "SelectionBounds")
            imageView.layer.masksToBounds = true
        }
    }
}

// MARK: - Custom Methods
extension NadoSegmentedControl {
    
    /// NadoSegmentedControl의 item들을 설정하는 메서드
    func setSegmentItems(items: [String]) {
        removeAllSegments()
        for i in 0..<items.count {
            insertSegment(withTitle: items[i], at: i, animated: false)
        }
        selectedSegmentIndex = 0
    }
}

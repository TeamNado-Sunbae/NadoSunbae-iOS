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
 - setButton: 버튼 기본 셋팅 변경
 - setTitle: 버튼 타이틀만 변경
 - changeColors: 버튼 배경색, 글씨색 변경
 */

final class NadoSegmentedControl: UISegmentedControl {
    
    // MARK: Properties
    private lazy var highlightView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 6
    }
    
    // MARK: init
    init(items: [String]) {
        super.init(frame: .zero)
        configureDefaultStyle()
        setSegmentItems(items: items)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureDefaultStyle()
        setUpNadoSegmentFrame()
    }
    
    // MARK: layoutSubViews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let finalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex) + 4.0
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.highlightView.frame.origin.x = finalXPosition
            }
        )
    }
}

// MARK: - UI
extension NadoSegmentedControl {
    
    /// NadoSegmentedControl의 기본 UI Style을 구성하는 메서드
    private func configureDefaultStyle() {
        backgroundColor = .segmentLightBgColor
        selectedSegmentTintColor = .clear
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
    
    /// NadoSegmentedControl의 Frame을 통해 HighlightView Frame을 설정하는 메서드
    func setUpNadoSegmentFrame() {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments) - 8.0
        let height = self.bounds.size.height - 8.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width)) + 4.0
        let yPosition = 4.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        highlightView.frame = frame
        addSubview(highlightView)
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

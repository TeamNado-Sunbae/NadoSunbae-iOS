//
//  NadoSwitch.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/10.
//

import UIKit

protocol SwitchButtonDelegate: AnyObject {
    func isOnValueChange(isOn: Bool)
}

final class NadoSwitch: UIButton {
    
    // MARK: Properties
    private var barView: UIView!
    private var circleView: UIView!
    
    typealias SwitchColor = (bar: UIColor, circle: UIColor)
    
    // barView의 상, 하단 마진 값
    var barViewTopBottomMargin: CGFloat = 3
    
    // on 상태의 스위치 색상
    var onColor: SwitchColor = (UIColor.mainDefault, UIColor.white) {
        didSet {
            if isOn {
                self.barView.backgroundColor = self.onColor.bar
                self.circleView.backgroundColor = self.onColor.circle
            }
        }
    }
    
    // off 상태의 스위치 색상
    var offColor: SwitchColor = (UIColor.gray1, UIColor.white) {
        didSet {
            if isOn == false {
                self.barView.backgroundColor = self.offColor.bar
                self.circleView.backgroundColor = self.offColor.circle
            }
        }
    }
    
    var isOn: Bool = false
    
    // 스위치가 이동하는 애니메이션 시간
    var animationDuration: TimeInterval = 0.25
    weak var switchDelegate: SwitchButtonDelegate?
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buttonInit(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.buttonInit(frame: frame)
    }
}

// MARK: - UI
extension NadoSwitch {
    private func buttonInit(frame: CGRect) {
        let barViewHeight = frame.height - (barViewTopBottomMargin * 2)
        barView = UIView(frame: CGRect(x: 0, y: barViewTopBottomMargin, width: frame.width, height: barViewHeight))
        barView.backgroundColor = self.offColor.bar
        barView.layer.masksToBounds = true
        barView.layer.cornerRadius = barViewHeight / 2
        
        circleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        circleView.backgroundColor = self.offColor.circle
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = frame.height / 2
        circleView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor(red: 0.471, green: 0.479, blue: 0.521, alpha: 0.25), opacity: 1, radius: 5)
        
        self.addSubviews([barView, circleView])
    }
}

// MARK: - Custom Methods
extension NadoSwitch {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setOn(on: !self.isOn)
        changeState()
    }
    
    private func setOn(on: Bool) {
        self.isOn = on
    }
    
    /// switch의 state를 설정하는 메서드
    private func setSwitchState() {
        self.circleView.center.x = self.isOn ? self.frame.width - (self.circleView.frame.width / 2) : self.circleView.frame.width / 2
        self.barView.backgroundColor = self.isOn ? self.onColor.bar : self.offColor.bar
        self.circleView.backgroundColor = self.isOn ? self.onColor.circle : self.offColor.circle
    }
    
    /// switch의 state가 변화될 때 애니메이션을 그리는 메서드
    private func changeState() {
        var circleCenter: CGFloat = 0
        var barViewColor: UIColor = .clear
        var circleViewColor: UIColor = .clear
        
        if self.isOn {
            circleCenter = self.frame.width - (self.circleView.frame.width / 2)
            barViewColor = self.onColor.bar
            circleViewColor = self.onColor.circle
        } else {
            circleCenter = self.circleView.frame.width / 2
            barViewColor = self.offColor.bar
            circleViewColor = self.offColor.circle
        }
        
        UIView.animate(withDuration: self.animationDuration, animations: { [weak self] in
            guard let self = self else { return }
            
            self.circleView.center.x = circleCenter
            self.barView.backgroundColor = barViewColor
            self.circleView.backgroundColor = circleViewColor
        }, completion: { [weak self] _ in
            guard let self = self else { return }

            self.switchDelegate?.isOnValueChange(isOn: self.isOn)
        })
    }
    
    /// 외부에서 switch의 state를 설정하는 메서드
    func setUpNadoSwitchState(isOn: Bool) {
        setOn(on: isOn)
        setSwitchState()
    }
}

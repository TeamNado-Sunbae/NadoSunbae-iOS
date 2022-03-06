//
//  NadoHorizonContainerViews.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit

class NadoHorizonContainerViews: UIView {
    
    @IBOutlet var externalSV: UIScrollView!
    @IBOutlet var containerStackView: UIStackView!
    @IBOutlet var firstContainerView: UIView!
    @IBOutlet var secondContainerView: UIView!
    @IBOutlet var contentViewWidth: NSLayoutConstraint!
    
    let xibName = NadoHorizonContainerViews.className
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}

// MARK: - Custom Methods
extension NadoHorizonContainerViews {

    /// contentView의 width를 컨테이너의 수만큼 곱해주는 메서드
    func setMultiplier(containerCount: CGFloat) {
        contentViewWidth = contentViewWidth.setMultiplier(multiplier: containerCount)
    }
}

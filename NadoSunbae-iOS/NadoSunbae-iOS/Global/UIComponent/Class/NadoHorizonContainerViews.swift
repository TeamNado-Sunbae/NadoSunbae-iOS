//
//  NadoHorizonContainerViews.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit

class NadoHorizonContainerViews: UIView {
    
    @IBOutlet var externalSV: UIScrollView!
    @IBOutlet var firstContainerView: UIView!
    @IBOutlet var secondContainerView: UIView!
    
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

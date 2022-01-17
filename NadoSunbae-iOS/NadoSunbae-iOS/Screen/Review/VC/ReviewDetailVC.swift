//
//  ReviewDetailVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailVC: UIViewController {

    @IBOutlet weak var naviBarView: NadoSunbaeNaviBar! {
        didSet {
            naviBarView.setUpNaviStyle(state: .backDefault)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    var receivedTitleLabel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()

    }

    func setUpData() {
        //titleLabel.text = receivedTitleLabel
    }
}


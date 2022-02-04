//
//  FilterVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/02/04.
//

import UIKit

class FilterVC: UIViewController {

    @IBOutlet weak var majorView: UIView!
    @IBOutlet weak var secondMajorView: UIView!
    @IBOutlet weak var learnInfoView: UIView!
    @IBOutlet weak var badClassView: UIView!
    @IBOutlet weak var recommendClassView: UIView!
    @IBOutlet weak var futureJobView: UIView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var completeBtn: NadoSunbaeBtn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @IBAction func tapDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilterVC {
    private func configureUI() {
        completeBtn.isActivated = false
        completeBtn.setTitle("적용하기", for: .normal)
        
        majorView.makeRounded(cornerRadius: 12)
        secondMajorView.makeRounded(cornerRadius: 12)
        learnInfoView.makeRounded(cornerRadius: 12)
        badClassView.makeRounded(cornerRadius: 12)
        recommendClassView.makeRounded(cornerRadius: 12)
        futureJobView.makeRounded(cornerRadius: 12)
        tipView.makeRounded(cornerRadius: 12)
        resetView.makeRounded(cornerRadius: 14)
    }
}

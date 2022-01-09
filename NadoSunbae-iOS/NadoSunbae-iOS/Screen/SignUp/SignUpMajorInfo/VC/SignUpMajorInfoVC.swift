//
//  SignUpMajorInfoVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/09.
//

import UIKit

class SignUpMajorInfoVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var univTextField: NadoTextField!
    @IBOutlet weak var firstMajorTextField: NadoTextField!
    @IBOutlet weak var firstMajorStartTextField: NadoTextField!
    @IBOutlet weak var secondMajorTextField: NadoTextField!
    @IBOutlet weak var secondMajorStartTextField: NadoTextField!
    @IBOutlet weak var nextBtn: NadoSunbaeBtn!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Custom Method
    private func configureUI() {
    }
    
    // MARK: IBAction
    @IBAction func tapPrevBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

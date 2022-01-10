//
//  SelectMajorModalVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/10.
//

import UIKit

class SelectMajorModalVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var completeBtn: NadoSunbaeBtn!
    @IBOutlet weak var selectMajorTV: UITableView!
    
    var majorList = ["나도학과", "선배학과"]
    var selectMajorDelegate: SendUpdateDelegate?

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTV()
    }
    
    // MARK: Custom Method
    private func configureUI() {
        completeBtn.setTitleWithStyle(title: "선택 완료", size: 16, weight: .semiBold)
        completeBtn.isEnabled = false
    }
    
    private func setUpTV() {
        selectMajorTV.dataSource = self
        selectMajorTV.delegate = self
    }
    
    // MARK: IBAction
    @IBAction func tapCompleteBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        selectMajorDelegate?.sendUpdate(data: majorList[selectMajorTV.indexPathForSelectedRow?.row ?? 0])
    }
    
    @IBAction func tapDismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

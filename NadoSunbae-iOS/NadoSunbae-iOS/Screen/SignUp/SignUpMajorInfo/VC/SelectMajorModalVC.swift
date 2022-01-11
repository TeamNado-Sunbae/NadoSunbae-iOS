//
//  SelectMajorModalVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/10.
//

import UIKit

class SelectMajorModalVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completeBtn: NadoSunbaeBtn!
    @IBOutlet weak var selectMajorTV: UITableView!
    
    /// 진입된 버튼의 태그, 0: 본전공, 1: 본전공진입시기, 2: 제2전공, 3: 제2전공진입시기
    var enterdBtnTag = 0
    
    var majorList = ["나도학과", "선배학과"]
    var startList = ["19-1", "19-2", "20-1", "20-2"]
    var selectMajorDelegate: SendUpdateModalDelegate?
    
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
        /// enterBtnTag에 맞춰서 타이틀 변경
        titleLabel.text = { () -> String in
            switch enterdBtnTag {
            case 0:
                return "본전공"
            case 1:
                return "본전공 진입시기"
            case 2:
                return "제2전공"
            case 3:
                return "제2전공 진입시기"
            default:
                return ""
            }
        }()
    }
    
    private func setUpTV() {
        selectMajorTV.dataSource = self
        selectMajorTV.delegate = self
    }
    
    // MARK: IBAction
    @IBAction func tapCompleteBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        let sendData = { () -> String in
            switch self.enterdBtnTag {
            case 0, 2:
                return self.majorList[self.selectMajorTV.indexPathForSelectedRow?.row ?? 0]
            case 1, 3:
                return self.startList[self.selectMajorTV.indexPathForSelectedRow?.row ?? 0]
            default:
                return ""
            }
        }()
        selectMajorDelegate?.sendUpdate(data: sendData)
    }
    
    @IBAction func tapDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

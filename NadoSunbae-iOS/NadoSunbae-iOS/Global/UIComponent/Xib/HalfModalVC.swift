//
//  HalfModalVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit
import Moya

class HalfModalVC: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var majorTV: UITableView!
    @IBOutlet weak var majorChooseBtn: NadoSunbaeBtn!
    
    // MARK: Properties
    private var majorList: [MajorInfoModel] = []
    var selectMajorDelegate: SendUpdateModalDelegate?
    var selectFilterDelegate: SendUpdateStatusDelegate?
    
    // MARK: Life Cycle Part
    override func viewDidLoad() {
        super.viewDidLoad()
        majorList = MajorInfo.shared.majorList ?? []
        setUpTV()
        majorTV.reloadData()
        configureBtnUI()
        tapMajorChooseBtnAction()
    }
    
    // MARK: IBAction
    @IBAction func tapDismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    
    /// TableView setting 함수
    private func setUpTV() {
        MajorTVC.register(target: majorTV)
        
        majorTV.dataSource = self
        majorTV.delegate = self
    }
    
    /// 선택완료 버튼 UI  setting 함수
    private func configureBtnUI() {
        majorChooseBtn.isActivated = false
        majorChooseBtn.setTitle("선택 완료", for: .normal)
    }
    
    /// 선택완료 버튼 클릭 시 데이터 전달
    private func tapMajorChooseBtnAction() {
        majorChooseBtn.press {
            let selectedMajorName = self.majorList[self.majorTV.indexPathForSelectedRow?.row ?? 0].majorName
            let selectedMajorID = self.majorList[self.majorTV.indexPathForSelectedRow?.row ?? 0].majorID

            if let selectMajorDelegate = self.selectMajorDelegate {
                MajorInfo.shared.selectedMajorName = selectedMajorName
                MajorInfo.shared.selectedMajorID = selectedMajorID
                selectMajorDelegate.sendUpdate(data: selectedMajorName)
            }
            
            if self.selectFilterDelegate != nil {
                ReviewFilterInfo.shared.selectedBtnList = [false, false, false, false, false, false, false]
                self.selectFilterDelegate?.sendStatus(data: false)
            }
    
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
            })
        }
    }
}

// MARK: - UITableViewDelegate
extension HalfModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

// MARK: - UITableViewDelegate
extension HalfModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return majorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorTVC.className) as? MajorTVC else { return UITableViewCell() }
        
        cell.setData(majorName: majorList[indexPath.row].majorName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        majorChooseBtn.isActivated = true
        majorChooseBtn.titleLabel?.textColor = UIColor.mainDefault
    }
}

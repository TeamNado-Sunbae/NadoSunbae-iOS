//
//  BlockListVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class BlockListVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.configureTitleLabel(title: "차단 사용자 목록")
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var blockListTV: UITableView! {
        didSet {
            blockListTV.dataSource = self
            blockListTV.rowHeight = 63.adjustedH
        }
    }
    @IBOutlet weak var emptyView: UIView! {
        didSet {
            emptyView.isHidden = true
            emptyView.makeRounded(cornerRadius: 8.adjusted)
        }
    }
    
    // MARK: Properties
    var blockList: [GetBlockListResponseModel] = []
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBlockList()
    }
}

// MARK: - UITableViewDataSource
extension BlockListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockListTVC.className, for: indexPath) as? BlockListTVC else { return UITableViewCell() }
        cell.undoBlockBtn.tag = indexPath.row
        cell.setData(data: blockList[indexPath.row])
        cell.undoBlockBtn.addTarget(self, action: #selector(doUnblock(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func doUnblock(_ sender: UIButton) {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        
        alert.cancelBtn.press {
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.confirmBtn.press {
            self.requestUnblockUser(blockUserID: self.blockList[sender.tag].userID)
        }
        
        alert.showNadoAlert(vc: self, message: "\(self.blockList[sender.tag].nickname)님을\n차단 해제하시겠습니까?", confirmBtnTitle: "차단 해제", cancelBtnTitle: "취소")
    }
}

// MARK: - Network
extension BlockListVC {
    private func getBlockList() {
        self.activityIndicator.startAnimating()
        MypageSettingAPI.shared.getBlockList { networkResult in
            switch networkResult {
            case .success(let res):
                if let response = res as? [GetBlockListResponseModel] {
                    self.blockList = response
                    self.emptyView.isHidden = !(self.blockList.isEmpty)
                    self.blockListTV.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print("request err: ", message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    private func requestUnblockUser(blockUserID: Int) {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.requestBlockUnBlockUser(blockUserID: blockUserID) { networkResult in
            switch networkResult {
            case .success(let res):
                if res is RequestBlockUnblockUserModel {
                    self.getBlockList()
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print("request err: ", message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

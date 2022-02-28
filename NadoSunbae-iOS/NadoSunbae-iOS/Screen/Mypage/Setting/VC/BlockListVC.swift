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
    
    // MARK: Properties
    var blockList: [GetBlockListResponseModel] = []
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension BlockListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockListTVC.className, for: indexPath) as? BlockListTVC else { return UITableViewCell() }
        cell.setData(data: blockList[indexPath.row])
        
        return cell
    }
}

// MARK: - Network
extension BlockListVC {
    
}

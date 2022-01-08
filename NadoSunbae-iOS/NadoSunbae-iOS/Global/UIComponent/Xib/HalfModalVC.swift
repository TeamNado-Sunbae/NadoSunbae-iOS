//
//  HalfModalVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit

class HalfModalVC: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var reviewTV: UITableView!
    
    // MARK: Vars
    var majorList: [ReviewData] = []
    
    // MARK: Life Cycle Part
    override func viewDidLoad() {
        super.viewDidLoad()
        initMajorList()
        setUpTV()
    }
    
    // MARK: IBAction
    @IBAction func tapDismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    /// 학과 이름 리스트 삽입 함수
    private func initMajorList() {
        majorList.append(contentsOf: [
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순"),
            ReviewData(majorName: "학과 이름 가나다순")
        ])
    }
    
    /// TableView setting 함수
    private func setUpTV() {
        MajorTVC.register(target: reviewTV)
        
        reviewTV.dataSource = self
        reviewTV.delegate = self
    }
}

// MARK: - Extension Part
extension HalfModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension HalfModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return majorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorTVC.className) as? MajorTVC else { return UITableViewCell() }
        
        cell.setData(reviewData: majorList[indexPath.row])
        return cell
    }
    
}

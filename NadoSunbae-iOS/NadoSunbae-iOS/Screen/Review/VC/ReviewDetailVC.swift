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
    @IBOutlet weak var reviewPostTV: UITableView!
    
    var detailPostList: [ReviewDetailData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTVC()
        setUpTV()
        initPostList()

    }
    
    private func registerTVC() {
        ReviewDetailPostTVC.register(target: reviewPostTV)
    }
    
    private func setUpTV() {
        reviewPostTV.dataSource = self
        reviewPostTV.delegate = self
    }
    
    private func initPostList() {
        detailPostList.append(contentsOf: [
            ReviewDetailData.init(iconImgName: "cube", title: "장단점", content: "난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼"),
            ReviewDetailData.init(iconImgName: "bomb", title: "추천수업", content: "난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼"),
            ReviewDetailData.init(iconImgName: "honey", title: "꿀팁", content: "난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼")
        ])
    }
}

extension ReviewDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 313.adjustedH
    }
}

extension ReviewDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewDetailPostTVC.className) as? ReviewDetailPostTVC else { return UITableViewCell() }
        
        cell.setData(postData: detailPostList[indexPath.row])
        return cell
    }
}


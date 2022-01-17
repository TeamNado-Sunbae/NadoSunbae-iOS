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
    
    var detailEssentialPostList: [ReviewEssentialData] = []
    var detailPostList: [ReviewDetailData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTVC()
        setUpTV()
        initEssentialPostList()
        initPostList()

    }
    
    private func registerTVC() {
        ReviewDetailPostWithImgTVC.register(target: reviewPostTV)
        ReviewDetailPostTVC.register(target: reviewPostTV)
    }
    
    private func setUpTV() {
        reviewPostTV.dataSource = self
        reviewPostTV.delegate = self
    
    }
    
    private func initEssentialPostList() {
        detailEssentialPostList.append(contentsOf: [
            ReviewEssentialData.init(bgImg: "imgReviewBg", content: "난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼")
        ])
    }
    
    private func initPostList() {
        detailPostList.append(contentsOf: [
            ReviewDetailData.init(iconImgName: "bomb", title: "추천수업", content: "난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼"),
            ReviewDetailData.init(iconImgName: "honey", title: "꿀팁", content: "난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고난 자유롭고 싶어 지금 전투력 수치 111퍼난 자유롭고 싶어 지금 전투력 수치 111퍼")
        ])
    }
}

extension ReviewDetailVC: UITableViewDelegate {
    
    /// section 3개로 나눔
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 517
        } else if indexPath.section == 1 {
            return 313
        } else {
            return 0
        }
    }
}

extension ReviewDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return detailEssentialPostList.count
        } else if section == 1 {
            return detailPostList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviewDetailPostWithImgTVC = tableView.dequeueReusableCell(withIdentifier: ReviewDetailPostWithImgTVC.className) as? ReviewDetailPostWithImgTVC,
              let reviewDetailPostTVC = tableView.dequeueReusableCell(withIdentifier: ReviewDetailPostTVC.className) as? ReviewDetailPostTVC else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            reviewDetailPostWithImgTVC.setData(postData: detailEssentialPostList[indexPath.row])
            return reviewDetailPostWithImgTVC
        } else if indexPath.section == 1 {
            reviewDetailPostTVC.setData(postData: detailPostList[indexPath.row])
            return reviewDetailPostTVC
        } else {
            return UITableViewCell()
        }
    }
}

//
//  ReviewMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class ReviewMainVC: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var naviBarView: UIView!
    @IBOutlet weak var reviewTV: UITableView!
    
    // MARK: Properties
    var imgList: [ReviewImgData] = []
    var postList: [ReviewPostData] = []
    
    // MARK: Life Cycle Part
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTVC()
        setUpTV()
        initImgList()
        initPostList()
        addShadowToNaviBar()
    }
    
    // MARK: Custom Methods
    
    /// cell 등록 함수
    private func registerTVC() {
        ReviewMainImgTVC.register(target: reviewTV)
        ReviewMainLinkTVC.register(target: reviewTV)
        ReviewMainPostTVC.register(target: reviewTV)
        
        let nib = UINib(nibName: "ReviewMainStickyHeader", bundle: nil)
        reviewTV.register(nib, forHeaderFooterViewReuseIdentifier: ReviewStickyHeaderView.className)
    }
    
    /// TableView setting 함수
    private func setUpTV() {
        reviewTV.dataSource = self
        reviewTV.delegate = self
        
        /// TableView 하단 space 설정
        reviewTV.contentInset.bottom = 16
        
        /// section header 들어가지 않는 section에 padding 값 없도록
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.0
        }
    }
    
    /// section0: 이미지 삽입
    private func initImgList() {
        imgList.append(contentsOf: [
            ReviewImgData(reviewImgName: "sampleImg")
        ])
    }
    
    /// section2: 게시글 리스트 삽입
    private func initPostList() {
        postList.append(contentsOf: [
            ReviewPostData(date: "21/12/23", title: "난 자유롭고 싶어 지금 전투력 수치 111퍼", diamondCount: 12, firstTagImgName: "icReviewTag", secondTagImgName: "icTipTag", thirdTagImgName: "icBadClassTag", majorName: "18-1", secondMajorName: "18-2"),
            ReviewPostData(date: "21/12/24", title: "아요 사랑해", diamondCount: 4, firstTagImgName: "icBadClassTag", secondTagImgName: "", thirdTagImgName: "", majorName: "18-1", secondMajorName: "18-2"),
            ReviewPostData(date: "22/01/01", title: "나도 선배 사랑해", diamondCount: 34, firstTagImgName: "icTipTag", secondTagImgName: "icBadClassTag", thirdTagImgName: "", majorName: "18-1", secondMajorName: "18-2"),
            ReviewPostData(date: "22/01/02", title: "우리가 짱이다~~~", diamondCount: 21, firstTagImgName: "icReviewTag", secondTagImgName: "icBadClassTag", thirdTagImgName: "", majorName: "18-1", secondMajorName: "18-2"),
            ReviewPostData(date: "22/01/03", title: "난 자유롭고 싶어 지금 전투력 수치 111퍼", diamondCount: 1, firstTagImgName: "icReviewTag", secondTagImgName: "icTipTag", thirdTagImgName: "", majorName: "18-1", secondMajorName: "18-2"),
        ])
    }
    
    // MARK: @objc Function Part
    @objc func showHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    // MARK: IBAction
    @IBAction func tapNaviBarBtn(_ sender: Any) {
        showHalfModalView()
    }
}

// MARK: - UI
extension ReviewMainVC {
    
    /// NaviBar dropShadow 설정 함수
    private func addShadowToNaviBar() {
        naviBarView.layer.shadowColor = UIColor(red: 0.898, green: 0.898, blue: 0.91, alpha: 0.16).cgColor
        naviBarView.layer.shadowOffset = CGSize(width: 0, height: 9)
        naviBarView.layer.shadowRadius = 18
        naviBarView.layer.shadowOpacity = 1
        naviBarView.layer.masksToBounds = false
    }
}

// MARK: - Custom Methods
extension ReviewMainVC {
    
    /// 액션시트
    func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // TODO: 액션 추가 예정
        let new = UIAlertAction(title: "최신순", style: .default) { action in
            print("최신순 선택")
        }
        
        // TODO: 액션 추가 예정
        let like = UIAlertAction(title: "좋아요순", style: .default) { action in
            print("좋아요순 선택")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(new)
        alert.addAction(like)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ReviewMainVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - UITableViewDelegate
extension ReviewMainVC: UITableViewDelegate {
    
    /// section 3개로 나눔
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// cell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 192.adjustedH
        } else if indexPath.section == 1 {
            return 52.adjustedH
        } else if indexPath.section == 2 {
            return 156
        } else {
            return 0
        }
    }
}

// MARK: - UITableViewDataSource
extension ReviewMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return postList.count
        } else {
            return 0
        }
    }
    
    /// section header view 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewStickyHeaderView.className) as? ReviewStickyHeaderView else { return UIView() }
            
            headerView.tapArrangeBtnAction = {
                self.showActionSheet()
            }
            return headerView
        } else {
            return nil
        }
    }
    
    /// section header 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 48
        } else {
            return 0
        }
    }
    
    /// row에 들어갈 cell 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviewMainImgTVC = tableView.dequeueReusableCell(withIdentifier: ReviewMainImgTVC.className) as? ReviewMainImgTVC,
              let reviewMainLinkTVC = tableView.dequeueReusableCell(withIdentifier: ReviewMainLinkTVC.className) as? ReviewMainLinkTVC,
              let reviewMainPostTVC = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className) as? ReviewMainPostTVC else { return UITableViewCell() }

        if indexPath.section == 0 {
            reviewMainImgTVC.setData(ImgData: imgList[indexPath.row])
            return reviewMainImgTVC
        } else if indexPath.section == 1 {
            return reviewMainLinkTVC
        } else if indexPath.section == 2 {
            reviewMainPostTVC.setData(postData: postList[indexPath.row])
            return reviewMainPostTVC
        } else {
            return UITableViewCell()
        }
    }
}


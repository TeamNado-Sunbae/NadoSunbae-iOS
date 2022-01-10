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
    
    // MARK: Life Cycle Part
    override func viewDidLoad() {
        super.viewDidLoad()
        initImgList()
        setUpTV()
        addShadowToNaviBar()
    }
    
    /// 만들어 둔 HalfModalView 보여주는 함수
    @objc func showHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    private func initImgList() {
        imgList.append(contentsOf: [
            ReviewImgData(reviewImgName: "sampleImg")
        ])
    }
    
    /// TableView setting 함수
    private func setUpTV() {
        ReviewMainImgTVC.register(target: reviewTV)
        
        reviewTV.dataSource = self
        reviewTV.delegate = self
    }
    
    // MARK: IBAction
    @IBAction func tapNaviBarBtn(_ sender: Any) {
        showHalfModalView()
    }
}

// MARK: - Extension Part
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

// MARK: - UIViewControllerTransitioningDelegate
extension ReviewMainVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ReviewMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 192
    }
}

extension ReviewMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewMainImgTVC.className) as? ReviewMainImgTVC else { return UITableViewCell() }
        
        cell.setData(ImgData: imgList[indexPath.row])
        return cell
    }
    
    
}



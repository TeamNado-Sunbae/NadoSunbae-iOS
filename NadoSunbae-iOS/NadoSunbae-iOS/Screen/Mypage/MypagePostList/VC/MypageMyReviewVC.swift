//
//  MypageMyReviewVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/19.
//

import UIKit

class MypageMyReviewVC: BaseVC {

    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.configureTitleLabel(title: "학과후기")
            navView.setUpNaviStyle(state: .backDefault)
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMypageMyReview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI
extension MypageMyReviewVC {
    private func configureUI() {
        setTitleLabel()
    }
    
    private func setTitleLabel() {
        let attributedString = NSMutableAttributedString(string: "\("내 닉네임")님이 쓴 학과 후기")
        let text = "\("내 닉네임")님이 쓴 학과 후기"
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainDefault, range: (text as NSString).range(of: "내 닉네임"))
        titleLabel.attributedText = attributedString
    }
}

// MARK: - Network
extension MypageMyReviewVC {
    private func getMypageMyReview() {
        
    }
}

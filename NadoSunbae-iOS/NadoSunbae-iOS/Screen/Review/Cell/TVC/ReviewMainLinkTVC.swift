//
//  ReviewMainLinkTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewMainLinkTVC: BaseTVC {
    
    var homepageURL: String = ""
    var subjectTableURL: String = ""
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        requestGetHomePageList(majorID: MajorInfo.shared.selecteMajorID ?? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func tapHomePageBtn(_ sender: Any) {
        if let url = URL(string: "\(self.homepageURL)") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func tapSubjectBtn(_ sender: Any) {
        if let url = URL(string: "\(self.subjectTableURL)") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

/// 학과 홈페이지 URL 정보 조회
extension ReviewMainLinkTVC {
    func requestGetHomePageList(majorID: Int) {
        ReviewAPI.shared.getHomePageUrlAPI(majorID: majorID){ networkResult in
            switch networkResult {
                
            case .success(let res):
                print(res)
                if let data = res as? ReviewHomePageData {
                    self.homepageURL = data.homepage
                    self.subjectTableURL = data.subjectTable
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

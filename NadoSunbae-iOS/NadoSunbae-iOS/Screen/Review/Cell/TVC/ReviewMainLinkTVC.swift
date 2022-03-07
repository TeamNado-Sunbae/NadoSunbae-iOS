//
//  ReviewMainLinkTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewMainLinkTVC: BaseTVC {
    
    // MARK: Properties
    var homePageLink: String = ""
    var subjectTableLink: String = ""
    var tapHomePageBtnAction : (() -> ())?
    var tapSubjectBtnAction : (() -> ())?
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        requestGetHomePageList(majorID: MajorInfo.shared.selectedMajorID ?? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func tapHomePageBtn(_ sender: Any) {
        tapHomePageBtnAction?()
    }
    
    @IBAction func tapSubjectBtn(_ sender: Any) {
        tapSubjectBtnAction?()
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
                    self.homePageLink = data.homepage
                    self.subjectTableLink = data.subjectTable
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

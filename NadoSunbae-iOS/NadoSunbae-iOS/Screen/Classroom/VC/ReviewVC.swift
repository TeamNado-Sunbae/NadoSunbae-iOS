//
//  ReviewVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/09.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class ReviewVC: BaseVC {

    private let label = UILabel().then {
        $0.textColor = .mainDefault
        $0.font = .PretendardSB(size: 10.0)
        $0.text = "ReviewVC의 내용을 채워주세요!"
    }
    
    var contentSizeDelegate: SendContentSizeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentSizeDelegate?.sendContentSize(height: 300)
    }
}

// MARK: - UI
extension ReviewVC {
    private func configureUI() {
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
    }
}

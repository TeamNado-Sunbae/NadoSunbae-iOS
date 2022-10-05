//
//  HomeRankerView.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

enum RankerType {
    case first
    case secondThird
    case fourthFifth
}

final class HomeRankerView: UIView {
    
    // MARK: Components
    private (set) lazy var userNameLabel = UILabel().then {
        switch rankerType {
        case .first, .secondThird:
            $0.font = .PretendardSB(size: 10.adjusted)
        case .fourthFifth:
            $0.font = .PretendardSB(size: 8.adjusted)
        }
        $0.textColor = .mainLight
        $0.textAlignment = .center
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
        $0.setCharacterSpacing(-0.1)
    }
    private (set) lazy var responseRateLabel = UILabel().then {
        switch rankerType {
        case .first, .secondThird:
            $0.font = .PretendardM(size: 10.adjusted)
        case .fourthFifth:
            $0.font = .PretendardM(size: 8.adjusted)
        }
        $0.textColor = .mainDefault
        $0.textAlignment = .center
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    private (set) lazy var profileImgView = NadoMaskedImgView().then {
        $0.maskImg = UIImage(named: "property172")
    }
    
    // MARK: Properties
    var rankerType: RankerType = .first
    
    // MARK: Initialization
    init(type: RankerType) {
        super.init(frame: .zero)
        rankerType = type
        configureUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

// MARK: - UI
extension HomeRankerView {
    private func configureUI() {
        self.isUserInteractionEnabled = true
        addSubviews([userNameLabel, responseRateLabel, profileImgView])
        
        userNameLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        responseRateLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(2)
            $0.left.right.equalToSuperview()
        }
        
        switch rankerType {
        case .first:
            profileImgView.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(profileImgView.snp.width)
            }
        case .secondThird:
            profileImgView.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(2)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(profileImgView.snp.width)
            }
        case .fourthFifth:
            profileImgView.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(7)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(profileImgView.snp.width)
            }
        }
    }
}

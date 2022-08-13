//
//  HomeRecentReviewQuestionTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

class HomeRecentReviewQuestionTVC: BaseTVC {
    
    // MARK: Components
    private let recentCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .gray3
    }
    
    // MARK: - Properties
    private lazy var CVFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .zero
        $0.itemSize = CGSize.init(width: (screenWidth - 32) * 2 / 3, height: 153)
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HomeRecentReviewQuestionTVC {
    private func configureUI() {
        addSubviews([recentCV])
        
        recentCV.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

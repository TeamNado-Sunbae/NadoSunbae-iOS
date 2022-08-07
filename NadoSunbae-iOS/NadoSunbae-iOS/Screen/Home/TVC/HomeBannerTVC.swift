//
//  HomeBannerTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/06.
//

import UIKit
import SnapKit
import Then

class HomeBannerTVC: BaseTVC {
    
    // MARK: Components
    private let bannerCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    private lazy var segmentedControl = UISegmentedControl().then {
        $0.removeAllSegments()
        for i in 0..<bannerImaURLsData.count - 2 {
            $0.insertSegment(with: UIImage(named: "unselectedSegmentImage"), at: i, animated: false)
        }
        $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.selectedSegmentIndex = 0
        $0.setImage(UIImage(named: "selectedSegmentImage"), forSegmentAt: $0.selectedSegmentIndex)
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Properties
    private lazy var CVFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .zero
        $0.itemSize = CGSize.init(width: screenWidth, height: 104)
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
extension HomeTitleHeaderCell {
    private func configureUI() {
        
    }
}

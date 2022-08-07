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
    
    /// 첫 인덱스 -> 마지막 이미지, 마지막 인덱스 -> 첫 이미지 추가하기!
    private var bannerImaURLsData = ["https://user-images.githubusercontent.com/43312096/183249441-5ad2cffb-db34-421a-a23c-915415c0593a.png", "https://user-images.githubusercontent.com/43312096/183249428-0c5b531b-6290-40c3-80ec-2517c9c990f8.png", "https://user-images.githubusercontent.com/43312096/183249432-034f6b8b-5518-49ce-bd69-4e6f4764b071.png", "https://user-images.githubusercontent.com/43312096/183249433-17ae6687-1632-423b-929b-6c57ac51edf3.png", "https://user-images.githubusercontent.com/43312096/183249439-97333cf5-a88d-4d72-8dca-9641e4587260.png", "https://user-images.githubusercontent.com/43312096/183249441-5ad2cffb-db34-421a-a23c-915415c0593a.png", "https://user-images.githubusercontent.com/43312096/183249428-0c5b531b-6290-40c3-80ec-2517c9c990f8.png"]
    
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

//
//  HomeBannerTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/06.
//

import UIKit
import SnapKit
import Then

final class HomeBannerTVC: BaseTVC {
    
    // MARK: Components
    private let bannerCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    private lazy var pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .init(white: 1, alpha: 0.5)
        $0.currentPageIndicatorTintColor = .white
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
    private var bannerImaURLsData = ["", "", "", "", ""]
    private var bannerRedirectURLsData: [String] = []
    var sendUpdateDelegate: SendUpdateModalDelegate?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setBannerCV()
        getBannerList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBannerCV() {
        bannerCV.dataSource = self
        bannerCV.delegate = self
        
        bannerCV.collectionViewLayout = CVFlowLayout
        bannerCV.register(HomeBannerCVC.self, forCellWithReuseIdentifier: HomeBannerCVC.className)
        
        DispatchQueue.main.async {
            self.bannerCV.scrollToItem(at: [0, 1], at: .left, animated: false)
        }
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = bannerImaURLsData.count - 2
    }
}

// MARK: - UICollectionViewDataSource
extension HomeBannerTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImaURLsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCVC.className, for: indexPath) as? HomeBannerCVC else { return UICollectionViewCell() }
        cell.setData(imageURL: bannerImaURLsData[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeBannerTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1, 4:
            sendUpdateDelegate?.sendUpdate(data: bannerRedirectURLsData[0])
        case 2:
            sendUpdateDelegate?.sendUpdate(data: bannerRedirectURLsData[1])
        case 0, 3:
            sendUpdateDelegate?.sendUpdate(data: bannerRedirectURLsData[2])
        default:
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageInt = Int(round(pageFloat))
        
        switch pageInt {
        case 0:
            pageControl.currentPage = bannerImaURLsData.count - 3
            bannerCV.scrollToItem(at: [0, bannerImaURLsData.count - 2], at: .left, animated: false)
        case bannerImaURLsData.count - 1:
            pageControl.currentPage = 0
            bannerCV.scrollToItem(at: [0, 1], at: .left, animated: false)
        default:
            pageControl.currentPage = pageInt - 1
        }
    }
}

// MARK: - UI
extension HomeBannerTVC {
    private func configureUI() {
        contentView.addSubviews([bannerCV, pageControl])
        
        bannerCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(8)
        }
    }
}

// MARK: - Network
extension HomeBannerTVC {
    private func getBannerList() {
        HomeAPI.shared.getBannerList { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? GetBannerListResponseData {
                    self.bannerImaURLsData = []
                    data.forEach {
                        self.bannerImaURLsData.append($0.imageURL)
                        self.bannerRedirectURLsData.append($0.redirectURL)
                    }
                    self.bannerImaURLsData.insert(self.bannerImaURLsData[data.count - 1], at: 0)
                    self.bannerImaURLsData.append(self.bannerImaURLsData[1])
                    self.setPageControl()
                    self.bannerCV.reloadData()
                }
            default:
                debugPrint(#function, "network error")
            }
        }
    }
}

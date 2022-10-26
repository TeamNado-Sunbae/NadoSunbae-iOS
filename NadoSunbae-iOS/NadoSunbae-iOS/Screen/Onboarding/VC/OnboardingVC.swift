//
//  OnboardingVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/03/08.
//

import UIKit

class OnboardingVC: BaseVC {

    // MARK: IBOutlet
    @IBOutlet weak var onboardingCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: NadoSunbaeBtn! {
        didSet {
            signUpBtn.isActivated = true
            signUpBtn.setTitleWithStyle(title: "회원가입", size: 14, weight: .semiBold)
            signUpBtn.makeRounded(cornerRadius: 8.adjusted)
        }
    }
    
    // MARK: Properties
    var onboardingData: [OnboardingContentData] = []
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpCV()
        registerCVC()
        initOnboardingData()
    }
    
    // MARK: IBAction
    @IBAction func tapSignUpBtn(_ sender: UIButton) {
        self.navigator?.instantiateVC(destinationViewControllerType: SignUpNC.self, useStoryboard: true, storyboardName: AgreeTermsVC.className, naviType: .present, modalPresentationStyle: .fullScreen) { destination in }
    }
    
    @IBAction func tapSignInBtn(_ sender: UIButton) {
        self.navigator?.instantiateVC(destinationViewControllerType: SignInVC.self, useStoryboard: true, storyboardName: "SignInSB", naviType: .present, modalPresentationStyle: .fullScreen) { destination in }
    }
}

// MARK: - UI
extension OnboardingVC {
    private func configureUI() {
        pageControl.isUserInteractionEnabled = false
    }
}

// MARK: - Custom Methods
extension OnboardingVC {
    private func setUpCV() {
        onboardingCV.delegate = self
        onboardingCV.dataSource = self
    }
    
    private func registerCVC() {
        OnboardingCVC.register(target: onboardingCV)
        FirstOnboardingCVC.register(target: onboardingCV)
    }
    
    private func initOnboardingData() {
        onboardingData.append(contentsOf: [
            OnboardingContentData(title: "생생한 학과 후기", subtitle: "장단점, 뭘배우나요?, 추천수업, 비추수업,\n향후진로, 꿀팁 등으로 구성되어 있어요.", onboardingImgName: "onboarding1"),
            OnboardingContentData(title: "선배와의 1:1 질문", subtitle: "궁금한 학과 선배의 페이지에 방문해\n1:1 질문을 작성해보세요.\n선배가 기존에 나눴던 질의응답도 확인할 수 있어요.", onboardingImgName: "onboarding2"),
            OnboardingContentData(title: "다양한 정보 공유까지 !", subtitle: "1:1 질문으로 해소되지 않은 내용은\n각 학과 학생들로 구성된 커뮤니티의\n질문, 정보, 자유 게시글을 통해서 해결해보세요.", onboardingImgName: "onboarding3")
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let onboardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCVC.className, for: indexPath) as? OnboardingCVC,
              let firstOnboardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstOnboardingCVC.className, for: indexPath) as? FirstOnboardingCVC else { return UICollectionViewCell() }
        
        
        if indexPath.row == 0 {
            return firstOnboardingCell
        } else {
            onboardingCell.setData(index: indexPath.row, contentData: onboardingData[indexPath.row - 1])
            return onboardingCell
        }
    }
}

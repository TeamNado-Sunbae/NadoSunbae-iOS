//
//  ClassroomMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import FirebaseAnalytics

final class ClassroomMainVC: BaseVC, View {
    
    // MARK: Properties
    private let majorLabel = UILabel().then {
        $0.text = UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)
        $0.font = .PretendardM(size: 20)
        $0.textColor = .black
        $0.sizeToFit()
    }

    private let bottomArrowImgView = UIImageView().then {
        $0.image = UIImage(named: "btnArrow")
    }

    private let topNaviView = UIView()
    private let majorSelectBtn = UIButton()
    private let reviewTV = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
    }
    
    var disposeBag = DisposeBag()
    let dataSource: RxTableViewSectionedReloadDataSource<ClassroomMainSection> = RxTableViewSectionedReloadDataSource(configureCell: { _, tableView, indexPath, items -> UITableViewCell in
        
        switch items {
        case .imageCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewMainImgTVC.className, for: indexPath)
            return cell
        case .reviewPostCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className, for: indexPath) as? ReviewMainPostTVC else { return UITableViewCell() }
            cell.setData(data: model)
            return cell
        case .questionCell(let reactor):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentQuestionTVC.className, for: indexPath) as? RecentQuestionTVC else { return UITableViewCell() }
            cell.reactor = reactor
            return cell
        case .findPersonHeaderCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionToPersonHeaderTVC.className, for: indexPath) as? QuestionToPersonHeaderTVC else { return UITableViewCell() }
            cell.setHeaderLabelText(headerText: "우리 과 선배 찾기")
            return cell
        case .findPersonCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: AvailableQuestionPersonTVC.className, for: indexPath)
            return cell
        case .recentQuestionHeaderCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionToPersonHeaderTVC.className, for: indexPath) as? QuestionToPersonHeaderTVC else { return UITableViewCell() }
            cell.hideSeeMoreBtn()
            cell.setHeaderLabelText(headerText: "최근 1:1 질문")
            return cell
        case .emptyCell:
            let cell = UITableViewCell()
            cell.backgroundColor = .paleGray
            return cell
        }
    })
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addShadowToNaviBar()
        setUpTV()
        registerTVC()
        tapMajorSelectBtn()
        requestGetMajorList(univID: 1, filterType: "all")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpMajorLabel()
        showTabbar()
        makeScreenAnalyticsEvent(screenName: "ClassRoom Tab", screenClass: ClassroomMainVC.className)
    }
    
    func bind(reactor: ClassroomMainReactor) {
        reviewTV.rx.setDelegate(self).disposed(by: disposeBag)
        bindState(reactor)
    }
}

// MARK: - Bind Action & State
extension ClassroomMainVC {
    private func bindState(_ reactor: ClassroomMainReactor) {
        reactor.state.map{ $0.sections }.asObservable()
            .bind(to: self.reviewTV.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.loading }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(onNext: { [weak self] loading in
                self?.view.bringSubviewToFront(self?.activityIndicator ?? UIView())
                loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension ClassroomMainVC {
    private func configureUI() {
        topNaviView.addSubviews([majorLabel, bottomArrowImgView, majorSelectBtn])
        self.view.addSubviews([topNaviView, reviewTV])
        self.view.backgroundColor = .paleGray
        
        majorLabel.snp.makeConstraints {
            $0.bottom.equalTo(topNaviView.snp.bottom).offset(-24)
            $0.leading.equalTo(topNaviView.snp.leading).offset(16)
        }
        
        bottomArrowImgView.snp.makeConstraints {
            $0.height.width.equalTo(48)
            $0.leading.equalTo(majorLabel.snp.trailing)
            $0.centerY.equalTo(majorLabel)
        }
        
        majorSelectBtn.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(bottomArrowImgView)
            $0.leading.equalTo(majorLabel)
        }
        
        topNaviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        reviewTV.snp.makeConstraints {
            $0.top.equalTo(topNaviView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// NaviBar dropShadow 설정 함수
    private func addShadowToNaviBar() {
        topNaviView.layer.shadowColor = UIColor(red: 0.898, green: 0.898, blue: 0.91, alpha: 0.16).cgColor
        topNaviView.layer.shadowOffset = CGSize(width: 0, height: 9)
        topNaviView.layer.shadowRadius = 18
        topNaviView.layer.shadowOpacity = 1
        topNaviView.layer.masksToBounds = false
    }
}

// MARK: - Custom Methods
extension ClassroomMainVC {
    
    /// cell 등록 함수
    private func registerTVC() {
        ReviewMainImgTVC.register(target: reviewTV)
        ReviewMainPostTVC.register(target: reviewTV)
        reviewTV.register(ClassroomMainHeaderView.self, forHeaderFooterViewReuseIdentifier: ClassroomMainHeaderView.className)
        ReviewEmptyTVC.register(target: reviewTV)
        QuestionToPersonHeaderTVC.register(target: reviewTV)
        AvailableQuestionPersonTVC.register(target: reviewTV)
    }
    
    /// tableView setting 함수
    private func setUpTV() {
        self.reviewTV.separatorStyle = .none
        self.reviewTV.backgroundColor = .paleGray

        /// TableView 하단 space 설정
        reviewTV.contentInset.bottom = 24

        /// section header 들어가지 않는 section에 padding 값 없도록
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.0
        }
    }
    
    /// HalfModalView를 present하는 메서드
    private func presentHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.vcType = .search
        slideVC.cellType = .star
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.selectMajorDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    /// 전공 선택 버튼을 tap했을 때 메서드
    private func tapMajorSelectBtn() {
        majorSelectBtn.press(vibrate: true) {
            self.presentHalfModalView()
        }
    }
    
    /// 전공 Label text를 set하는 메서드
    private func setUpMajorLabel() {
        majorLabel.text = (MajorInfo.shared.selectedMajorName != nil) ? MajorInfo.shared.selectedMajorName : UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ClassroomMainVC: UIViewControllerTransitioningDelegate {
    
    /// presentationController - forPresented
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - SendUpdateModalDelegate
extension ClassroomMainVC: SendUpdateModalDelegate {
    func sendUpdate(data: Any) {
        majorLabel.text = data as? String
    }
}

// MARK: - UITableViewDelegate
extension ClassroomMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ClassroomMainHeaderView.className) as? ClassroomMainHeaderView else { return UIView() }
            headerView.reactor = ClassroomMainReactor()
            
            headerView.rx.tapSegmentedControl
                .map { Reactor.Action.tapSegment(type: headerView.classroomSegmentedControl.selectedSegmentIndex) }
                .bind(to: reactor!.action)
                .disposed(by: disposeBag)
            
            return headerView
        }
        return nil
    }
    
    /// section header 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 56
        } else {
            return 0
        }
    }
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                return 16
            }
        }
        return UITableView.automaticDimension
    }
}

// MARK: - Network

/// 학과 정보 리스트 조회
extension ClassroomMainVC {
    private func requestGetMajorList(univID: Int, filterType: String) {
        PublicAPI.shared.getMajorListAPI(univID: univID, filterType: filterType) { networkResult in
            switch networkResult {
                
            case .success(let res):
                var list: [MajorInfoModel] = []
                DispatchQueue.main.async {
                    if let data = res as? [MajorListData] {
                        for i in 0...data.count - 1 {
                            list.append(MajorInfoModel(majorID: data[i].majorID, majorName: data[i].majorName))
                        }
                        MajorInfo.shared.majorList = list
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}

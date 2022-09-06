//
//  ClassroomMainHeaderView.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/08/15.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

class ClassroomMainHeaderView: UITableViewHeaderFooterView, View {

    lazy var classroomSegmentedControl = NadoSegmentedControl(items: ["후기", "1:1질문"]).then {
        $0.frame = CGRect(x: 16, y: 10, width: 160, height: 37)
    }
    
    lazy var filterBtn = UIButton().then {
        $0.setImgByName(name: "btnFilter", selectedName: "filterSelected")
    }
    
    private let arrangeBtn = UIButton().then {
        $0.setImgByName(name: "btnArray", selectedName: "property1Variant3")
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: setNeedsLayout
    override func setNeedsLayout() {
        classroomSegmentedControl.setUpNadoSegmentFrame()
    }
    
    func bind(reactor: ClassroomMainReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind Action & State
extension ClassroomMainHeaderView {
    private func bindAction(_ reactor: ClassroomMainReactor) {
        classroomSegmentedControl.rx.controlEvent(.valueChanged)
            .map { [weak self] in
                let selectIndex = self?.classroomSegmentedControl.selectedSegmentIndex
                
                switch selectIndex {
                case 1:
                    return ClassroomMainReactor.Action.tapQuestionSegment
                default:
                    return ClassroomMainReactor.Action.tapReviewSegment
                }
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        filterBtn.rx.tap
            .map { Reactor.Action.tapFilterBtn }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        arrangeBtn.rx.tap
            .map { Reactor.Action.tapArrangeBtn }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ClassroomMainReactor) {
        reactor.state.map { $0.isFilterBtnSelected }
            .distinctUntilChanged()
            .bind(to: filterBtn.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isArrangeBtnSelected }
            .distinctUntilChanged()
            .bind(to: arrangeBtn.rx.isSelected)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension ClassroomMainHeaderView {
    private func configureUI() {
        contentView.addSubviews([classroomSegmentedControl, filterBtn, arrangeBtn])
        contentView.backgroundColor = .white
        
        classroomSegmentedControl.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(160)
        }
        
        arrangeBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(classroomSegmentedControl)
            $0.width.equalTo(68)
            $0.height.equalTo(24)
        }
        
        filterBtn.snp.makeConstraints {
            $0.trailing.equalTo(arrangeBtn.snp.leading).offset(-12)
            $0.centerY.equalTo(classroomSegmentedControl)
            $0.width.equalTo(48)
            $0.height.equalTo(24)
        }
    }
}

// MARK: - Reactive
extension Reactive where Base: ClassroomMainHeaderView {
    var tapSegmentedControl: ControlEvent<Void> {
        ControlEvent(events: base.classroomSegmentedControl.rx.controlEvent(.valueChanged))
    }
}

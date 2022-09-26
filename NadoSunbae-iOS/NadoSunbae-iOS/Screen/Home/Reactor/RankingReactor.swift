//
//  RankingReactor.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/22.
//

import UIKit
import ReactorKit
import RxSwift

final class RankingReactor: Reactor {
    
    var initialState: State = State()
    
    enum Action {
        case tapCloseBtn
        case tapQuestionMarkBtn
        case viewDidLoad
    }
    
    enum Mutation {
        case setLoading(loading: Bool)
        case setInfoContentViewStatus(isHidden: Bool)
        case requestRankingList(rankingList: [RankingListModel])
    }
    
    struct State {
        var loading = false
        var rankingList: [RankingListModel] = []
        var isInfoContentViewHidden: Bool = true
    }
}

// MARK: - Reactor
extension RankingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapCloseBtn:
            return Observable.concat(Observable.just(.setInfoContentViewStatus(isHidden: true)))
        case .tapQuestionMarkBtn:
            return Observable.concat(Observable.just(.setInfoContentViewStatus(isHidden: false)))
        case .viewDidLoad:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestRankingList(),
                Observable.just(.setLoading(loading: false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let loading):
            newState.loading = loading
        case .setInfoContentViewStatus(let isHidden):
            newState.isInfoContentViewHidden = isHidden
        case .requestRankingList(let rankingList):
            newState.rankingList = rankingList
        }
        return newState
    }
}

// MARK: - Custom Methods
extension RankingReactor {
    private func requestRankingList() -> Observable<Mutation> {
        return Observable.create { observer in
            let dummyList = [
                RankingListModel(id: 1, profileImageID: 1, nickname: "안녕하세요", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "디지털미디어학과", secondMajorStart: "19-1", rate: 100),
                RankingListModel(id: 2, profileImageID: 2, nickname: "선배닉네임최대는", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "디지털미디어학과", secondMajorStart: "20-1", rate: 80),
                RankingListModel(id: 3, profileImageID: 3, nickname: "하이", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "반도체어쩌구학과", secondMajorStart: "22-1", rate: 70),
                RankingListModel(id: 4, profileImageID: 4, nickname: "나는지은", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "반도체어쩌구학과 (세종)", secondMajorStart: "22-1", rate: 90),
                RankingListModel(id: 5, profileImageID: 5, nickname: "나도선배", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "반도체어쩌구학과", secondMajorStart: "22-1", rate: 80),
                RankingListModel(id: 6, profileImageID: 2, nickname: "정숙이는개발천재", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "반도체어쩌구학과", secondMajorStart: "22-1", rate: 10),
                RankingListModel(id: 7, profileImageID: 3, nickname: "선배닉네임최대는", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "경제학과", secondMajorStart: "22-1", rate: 20),
            ]
            
            observer.onNext(Mutation.requestRankingList(rankingList: dummyList))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

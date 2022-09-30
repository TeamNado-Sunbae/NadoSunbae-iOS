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
        case requestRankingList(rankingList: [HomeRankingResponseModel.UserList])
    }
    
    struct State {
        var loading = false
        var rankingList: [HomeRankingResponseModel.UserList] = []
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
                self.requestRankingList()
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

// MARK: - Network
extension RankingReactor {
    private func requestRankingList() -> Observable<Mutation> {
        return Observable.create { observer in
            HomeAPI.shared.getUserRankingList { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? HomeRankingResponseModel {
                        observer.onNext(Mutation.requestRankingList(rankingList: data.userList))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    }
                default:
//                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    observer.onNext(Mutation.setLoading(loading: false))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

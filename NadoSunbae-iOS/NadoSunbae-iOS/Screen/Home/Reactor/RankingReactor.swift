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
        case reloadRankingList
    }
    
    enum Mutation {
        case setLoading(loading: Bool)
        case setInfoContentViewStatus(isHidden: Bool)
        case requestRankingList(rankingList: [HomeRankingResponseModel.UserList])
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
        case setUpdateAccessTokenAction(action: Action)
        case setUpdateAccessTokenState(state: Bool)
    }
    
    struct State {
        var loading = false
        var rankingList: [HomeRankingResponseModel.UserList] = []
        var isInfoContentViewHidden: Bool = true
        var showAlert: Bool = false
        var alertMessage: String = ""
        var isUpdateAccessToken: Bool = false
        var reRequestAction: Action = .reloadRankingList
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
        case .reloadRankingList:
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
        case .setAlertState(let showState, let message):
            newState.showAlert = showState
            newState.alertMessage = message
        case .setUpdateAccessTokenAction(let action):
            newState.reRequestAction = action
        case .setUpdateAccessTokenState(let state):
            newState.isUpdateAccessToken = state
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
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.setUpdateAccessTokenAction(action: .reloadRankingList))
                        observer.onNext(Mutation.setUpdateAccessTokenState(state: true))
                    }
                default:
                    observer.onNext(Mutation.setAlertState(showState: true))
                    observer.onNext(Mutation.setLoading(loading: false))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

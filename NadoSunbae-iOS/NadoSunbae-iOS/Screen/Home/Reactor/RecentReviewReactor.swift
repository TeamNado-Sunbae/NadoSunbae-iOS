//
//  RecentReviewReactor.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/23.
//

import UIKit
import ReactorKit
import RxSwift

final class RecentReviewReactor: Reactor {
    
    var initialState: State = State()
    
    enum Action {
        case reloadRecentReviewList
    }
    
    enum Mutation {
        case setLoading(loading: Bool)
        case requestRecentReviewList(reviewList: [HomeRecentReviewResponseDataElement])
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
        case setUpdateAccessTokenAction(action: Action)
        case setUpdateAccessTokenState(state: Bool)
    }
    
    struct State {
        var loading = false
        var recentReviewList: [HomeRecentReviewResponseDataElement] = []
        var showAlert: Bool = false
        var alertMessage: String = ""
        var isUpdateAccessToken: Bool = false
        var reRequestAction: Action = .reloadRecentReviewList
    }
}

// MARK: - Reactor
 extension RecentReviewReactor {
     func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .reloadRecentReviewList:
             return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestReviewList()
             ])
         }
     }

     func reduce(state: State, mutation: Mutation) -> State {
         var newState = state

         switch mutation {
         case .setLoading(let loading):
             newState.loading = loading
         case .requestRecentReviewList(let recentReviewList):
             newState.recentReviewList = recentReviewList
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
extension RecentReviewReactor {
    private func requestReviewList() -> Observable<Mutation> {
        return Observable.create { observer in
            HomeAPI.shared.getAllReviewList { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? [HomeRecentReviewResponseDataElement] {
                        observer.onNext(Mutation.requestRecentReviewList(reviewList: data))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.setUpdateAccessTokenAction(action: .reloadRecentReviewList))
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

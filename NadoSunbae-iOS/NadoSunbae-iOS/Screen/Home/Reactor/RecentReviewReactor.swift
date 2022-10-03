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
        case viewDidLoad
    }
    
    enum Mutation {
        case setLoading(loading: Bool)
        case requestRecentReviewList(reviewList: [HomeRecentReviewResponseDataElement])
    }
    
    struct State {
        var loading = false
        var recentReviewList: [HomeRecentReviewResponseDataElement] = []
    }
}

// MARK: - Reactor
 extension RecentReviewReactor {
     func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .viewDidLoad:
             return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestReviewList(),
                Observable.just(.setLoading(loading: false))
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

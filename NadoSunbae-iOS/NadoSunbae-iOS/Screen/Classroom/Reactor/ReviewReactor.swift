//
//  ReviewReactor.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/10/21.
//

import UIKit
import ReactorKit

final class ReviewReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: Action
    enum Action {
        case reloadReviewList
    }
    
    // MARK: Mutation
    enum Mutation {
        case setLoading(loading: Bool)
        case requestReviewList(reviewList: [ReviewMainPostListData])
    }
    
    // MARK: State
    struct State {
        var loading = false
        var reviewList: [ReviewMainPostListData] = []
    }
}

// MARK: - Reactor
extension ReviewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .reloadReviewList:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                requestReviewList(majorID: 6, writerFilter: "all", tagFilter: "1, 2, 3, 4, 5", sort: .recent)])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setLoading(let loading):
            newState.loading = loading
        case .requestReviewList(let reviewList):
            newState.reviewList = reviewList
        }
        
        return newState
    }
}

// MARK: - Network
extension ReviewReactor {
    
    private func requestReviewList(majorID: Int, writerFilter: String, tagFilter: String, sort: ListSortType) -> Observable<Mutation> {
        return Observable.create { observer in
            ReviewAPI.shared.getReviewPostListAPI(majorID: majorID, writerFilter: writerFilter, tagFilter: tagFilter, sort: sort) { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? [ReviewMainPostListData] {
                        observer.onNext(Mutation.requestReviewList(reviewList: data))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    }
                default:
                    // ✅ TODO: Alert Display Protocol화하기
                    // self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")

                    observer.onNext(Mutation.setLoading(loading: false))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

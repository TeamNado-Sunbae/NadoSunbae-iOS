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
    var sortType: ListSortType = .recent
    
    // MARK: Action
    enum Action {
        case reloadReviewList
    }
    
    // MARK: Mutation
    enum Mutation {
        case setLoading(loading: Bool)
        case requestReviewList(reviewList: [ReviewMainPostListData])
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
    }
    
    // MARK: State
    struct State {
        var loading = false
        var reviewList: [ReviewMainPostListData] = []
        var showAlert: Bool = false
        var alertMessage: String = ""
    }
}

// MARK: - Reactor
extension ReviewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .reloadReviewList:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                
                /// shared에 데이터가 있으면 shared정보로 데이터를 요청하고, 그렇지 않으면 Userdefaults의 전공ID로 요청
                requestReviewList(majorID: (MajorInfo.shared.selectedMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selectedMajorID ?? -1), writerFilter: "all", tagFilter: "1, 2, 3, 4, 5", sort: sortType)])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setLoading(let loading):
            newState.loading = loading
        case .requestReviewList(let reviewList):
            newState.reviewList = reviewList
        case .setAlertState(let showState, let message):
            newState.showAlert = showState
            newState.alertMessage = message
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
                    observer.onNext(.setAlertState(showState: true))
                    observer.onNext(Mutation.setLoading(loading: false))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

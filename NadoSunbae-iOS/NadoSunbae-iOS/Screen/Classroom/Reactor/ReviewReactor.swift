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
    var writerType: ReviewWriterType = .all
    var tagFilter = "1, 2, 3, 4, 5"
    
    // MARK: Action
    enum Action {
        case reloadReviewList
    }
    
    // MARK: Mutation
    enum Mutation {
        case setLoading(loading: Bool)
        case requestReviewList(reviewList: [ReviewMainPostListData])
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
        case setUpdateAccessTokenAction(action: Action)
        case setUpdateAccessTokenState(state: Bool)
    }
    
    // MARK: State
    struct State {
        var loading = false
        var reviewList: [ReviewMainPostListData] = []
        var showAlert: Bool = false
        var alertMessage: String = ""
        var isUpdateAccessToken: Bool = false
        var reRequestAction: Action = .reloadReviewList
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
                requestReviewList(majorID: (MajorInfo.shared.selectedMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selectedMajorID ?? -1), writerFilter: writerType, tagFilter: self.tagFilter, sort: sortType)])
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
        case .setUpdateAccessTokenAction(let action):
            newState.reRequestAction = action
        case .setUpdateAccessTokenState(let state):
            newState.isUpdateAccessToken = state
        }
        
        return newState
    }
}

// MARK: - Network
extension ReviewReactor {
    
    private func requestReviewList(majorID: Int, writerFilter: ReviewWriterType, tagFilter: String, sort: ListSortType) -> Observable<Mutation> {
        return Observable.create { observer in
            ReviewAPI.shared.getReviewPostListAPI(majorID: majorID, writerFilter: writerFilter, tagFilter: tagFilter, sort: sort) { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? [ReviewMainPostListData] {
                        observer.onNext(Mutation.requestReviewList(reviewList: data))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.setUpdateAccessTokenAction(action: .reloadReviewList))
                        observer.onNext(Mutation.setUpdateAccessTokenState(state: true))
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

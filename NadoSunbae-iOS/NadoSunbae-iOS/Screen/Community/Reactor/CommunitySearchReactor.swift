//
//  CommunitySearchReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/08/09.
//

import UIKit
import ReactorKit

final class CommunitySearchReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: represent user actions
    enum Action {
        case tapBackBtn
        case tapCompleteSearchBtn(searchKeyword: String)
        case requestNewSearchList(searchKeyword: String)
        case sendEmptyKeyword
    }
    
    // MARK: represent state changes
    enum Mutation {
        case setLoading(loading: Bool)
        case requestSearchList(searchList: [PostListResModel])
        case setSearchListEmpty
        case setSearchKeyword(keyword: String)
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
        case setUpdateAccessTokenAction(action: Action)
        case setUpdateAccessTokenState(state: Bool)
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var searchList: [PostListResModel] = []
        var searchKeyword: String = ""
        var showAlert: Bool = false
        var alertMessage: String = ""
        var isUpdateAccessToken: Bool = false
        var reRequestAction: Action = .requestNewSearchList(searchKeyword: "")
    }
}

// MARK: - Reactor
extension CommunitySearchReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapBackBtn:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .tapCompleteSearchBtn(let keyword):
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                Observable.just(.setSearchKeyword(keyword: keyword)),
                self.requestCommunitySearchList(majorID: 0, type: .community, sort: "recent", search: keyword),
                Observable.just(.setLoading(loading: false))
            ])
        case .sendEmptyKeyword:
            return Observable.concat(Observable.just(.setSearchListEmpty))
        case .requestNewSearchList(let searchKeyword):
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestCommunitySearchList(majorID: 0, type: .community, sort: "recent", search: searchKeyword),
                Observable.just(.setLoading(loading: false))
            ])
        }
    }
    
    /// reduce (Mutation -> State)
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setLoading(let loading):
            newState.loading = loading
        case .requestSearchList(let searchList):
            newState.searchList = searchList
        case .setSearchListEmpty:
            newState.searchList = []
        case .setAlertState(let showState, let message):
            newState.showAlert = showState
            newState.alertMessage = message
        case .setUpdateAccessTokenState(let state):
            newState.isUpdateAccessToken = state
        case .setSearchKeyword(let keyword):
            newState.searchKeyword = keyword
        case .setUpdateAccessTokenAction(let action):
            newState.reRequestAction = action
        }
        
        return newState
    }
}

// MARK: - Custom Methods
extension CommunitySearchReactor {
    private func requestCommunitySearchList(majorID: Int?, type: PostFilterType, sort: String?, search: String?)  -> Observable<Mutation> {
        return Observable.create { observer in
            PublicAPI.shared.getPostList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), majorID: majorID ?? 0, filter: type, sort: sort ?? "recent", search: search ?? "") { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? [PostListResModel] {
                        observer.onNext(Mutation.requestSearchList(searchList: data))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onNext(.setUpdateAccessTokenState(state: false))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.setUpdateAccessTokenAction(action: .requestNewSearchList(searchKeyword: search ?? "")))
                        observer.onNext(.setUpdateAccessTokenState(state: true))
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

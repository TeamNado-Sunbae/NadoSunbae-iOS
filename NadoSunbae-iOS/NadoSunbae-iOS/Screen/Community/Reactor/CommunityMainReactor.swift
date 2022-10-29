//
//  CommunityMainReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/23.
//

import UIKit
import ReactorKit

final class CommunityMainReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: represent user actions
    enum Action {
        case searchBtnDidTap
        case filterFilled(fill: Bool, majorID: Int, type: PostFilterType)
        case requestNewCommunityList(majorID: Int? = MajorIDConstants.allMajorID, type: PostFilterType, sort: String? = "recent", search: String? = "")
        case refreshControl(majorID: Int? = MajorIDConstants.allMajorID, type: PostFilterType, sort: String? = "recent", search: String? = "")
        case tapSegmentedControl(majorID: Int? = MajorIDConstants.allMajorID, type: PostFilterType, sort: String? = "recent", search: String? = "")
    }
    
    // MARK: represent state changes
    // Action과 State를 연결, Reactor Layer에만 존재
    enum Mutation {
        case setLoading(loading: Bool)
        case requestCommunityList(communityList: [PostListResModel])
        case setFilterBtnState(selected: Bool)
        case setFilterMajorID(majorID: Int)
        case setRefreshLoading(loading: Bool)
        case setAnimateToTopState(state: Bool)
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
        case setUpdateAccessTokenAction(action: Action)
        case setUpdateAccessTokenState(state: Bool)
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var refreshLoading: Bool = false
        var communityList: [PostListResModel] = []
        var majorList: [MajorInfoModel] = []
        var filterBtnSelected: Bool = false
        var filterMajorID: Int = MajorIDConstants.allMajorID
        var animateToTopState: Bool = true
        var showAlert: Bool = false
        var alertMessage: String = ""
        var isUpdateAccessToken: Bool = false
        var reRequestAction: Action = .requestNewCommunityList(type: .community)
    }
}

// MARK: - Reactor
extension CommunityMainReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .searchBtnDidTap:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .filterFilled(let fill, let majorID, let type):
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                Observable.just(.setFilterBtnState(selected: fill)),
                Observable.just(.setFilterMajorID(majorID: majorID)),
                Observable.just(.setAnimateToTopState(state: true)),
                self.requestCommunityList(majorID: majorID, type: type, sort: "recent", search: "")
            ])
        case .requestNewCommunityList(let majorID, let type, let sort, let search):
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestCommunityList(majorID: majorID, type: type, sort: sort, search: search)
            ])
        case .refreshControl(let majorID, let type, let sort, let search):
            return Observable.concat([
                Observable.just(.setRefreshLoading(loading: true)),
                self.requestCommunityList(majorID: majorID, type: type, sort: sort, search: search)
            ])
        case .tapSegmentedControl(let majorID, let type, let sort, let search):
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                Observable.just(.setAnimateToTopState(state: true)),
                self.requestCommunityList(majorID: majorID, type: type, sort: sort, search: search)
            ])
        }
    }
    
    /// reduce (Mutation -> State)
    /// 최종 State를 View로 방출
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setLoading(let loading):
            newState.loading = loading
        case .requestCommunityList(let communityList):
            newState.communityList = communityList
        case .setFilterBtnState(let selected):
            newState.filterBtnSelected = selected
        case .setRefreshLoading(let loading):
            newState.refreshLoading = loading
        case .setFilterMajorID(let majorID):
            newState.filterMajorID = majorID
        case .setAnimateToTopState(let state):
            newState.animateToTopState = state
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

// MARK: - Custom Methods
extension CommunityMainReactor {
    private func requestCommunityList(majorID: Int?, type: PostFilterType, sort: String?, search: String?) -> Observable<Mutation> {
        return Observable.create { observer in
            DispatchQueue.global().async {
                PublicAPI.shared.getPostList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), majorID: majorID ?? 0, filter: type, sort: sort ?? "recent", search: search ?? "") { networkResult in
                    switch networkResult {
                    case .success(let res):
                        if let data = res as? [PostListResModel] {
                            observer.onNext(Mutation.requestCommunityList(communityList: data))
                            observer.onNext(Mutation.setRefreshLoading(loading: false))
                            observer.onNext(Mutation.setUpdateAccessTokenState(state: false))
                            observer.onNext(Mutation.setLoading(loading: false))
                            observer.onNext(Mutation.setAnimateToTopState(state: false))
                            observer.onCompleted()
                        }
                    case .requestErr(let res):
                        if let _ = res as? String {
                            observer.onNext(Mutation.setAlertState(showState: true))
                            observer.onNext(Mutation.setLoading(loading: false))
                            observer.onCompleted()
                        } else if res is Bool {
                            observer.onNext(.setUpdateAccessTokenAction(action: .requestNewCommunityList(majorID: majorID, type: type, sort: sort, search: search)))
                            observer.onNext(Mutation.setUpdateAccessTokenState(state: true))
                        }
                    default:
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
}

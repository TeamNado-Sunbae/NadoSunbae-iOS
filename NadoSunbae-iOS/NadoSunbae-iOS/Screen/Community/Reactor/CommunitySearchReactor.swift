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
        case sendEmptyKeyword
    }
    
    // MARK: represent state changes
    enum Mutation {
        case setLoading(loading: Bool)
        case requestSearchList(searchList: [PostListResModel])
        case setSearchListEmpty
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var searchList: [PostListResModel] = []
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
                self.requestCommunitySearchList(majorID: 0, type: .community, sort: "recent", search: keyword),
                Observable.just(.setLoading(loading: false))
            ])
        case .sendEmptyKeyword:
            return Observable.concat(Observable.just(.setSearchListEmpty))
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
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    // ✅ TODO: Alert Display Protocol화 하기
                    if let message = res as? String {
//                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        // ✅ TODO: updateAccessToken Protocol화 하기
//                        self.updateAccessToken { _ in
//                            self.setUpRequestData(sortType: .recent)
//                        }
                    }
                default:
                    // ✅ TODO: Alert Display Protocol화하기
//                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    observer.onNext(Mutation.setLoading(loading: false))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

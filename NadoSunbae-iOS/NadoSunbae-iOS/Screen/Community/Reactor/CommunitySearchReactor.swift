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
    }
    
    // MARK: represent state changes
    enum Mutation {
        case setLoading(loading: Bool)
        case requestSearchList(searchList: [CommunityPostList])
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var searchList: [CommunityPostList] = []
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
                self.requestSearchListRx(searchKeyword: keyword),
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
        }
        
        return newState
    }
}

// MARK: - Custom Methods
extension CommunitySearchReactor {
    private func requestSearchListRx(searchKeyword: String) -> Observable<Mutation> {
        return Observable.create { observer in
            let dummyEntireList = [
                CommunityPostList(category: "전체", postID: 1, title: searchKeyword, content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "닉"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
                CommunityPostList(category: "전체", postID: 1, title: searchKeyword, content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "네"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
                CommunityPostList(category: "전체", postID: 1, title: searchKeyword, content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "임"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
                CommunityPostList(category: "전체", postID: 1, title: searchKeyword, content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "slr"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
                CommunityPostList(category: "전체", postID: 1, title: searchKeyword, content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "slr"), like: Like(isLiked: true, likeCount: 1), commentCount: 1)
            ].shuffled()
            
            observer.onNext(Mutation.requestSearchList(searchList: dummyEntireList))
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

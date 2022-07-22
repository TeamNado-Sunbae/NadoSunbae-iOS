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
        case touchUpSearchBtn
        case touchUpFilterBtn
        case reloadCommunityTV
        case touchUpEntireControl
        case touchUpFreeControl
        case touchUpQuestionControl
        case touchUpInfoControl
        case touchUpWriteFloatingBtn
    }
    
    // MARK: represent state changes
    // Action과 State를 연결, Reactor Layer에만 존재
    enum Mutation {
        case setLoading(loading: Bool)
        case requestCommunityList(communityLIst: [CommunityPostList])
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var communityList: [CommunityPostList] = []
    }
}

// MARK: - Reactor

extension CommunityMainReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .touchUpSearchBtn:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .touchUpFilterBtn:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .reloadCommunityTV:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestCommunityListRx(),
                Observable.just(.setLoading(loading: false))
            ])
        case .touchUpEntireControl:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .touchUpFreeControl:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .touchUpQuestionControl:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .touchUpInfoControl:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        case .touchUpWriteFloatingBtn:
            return Observable.concat(Observable.just(.setLoading(loading: true)))
        }
    }
    
    /// reduce (Mutation -> State)
    /// 최종 State를 View로 방출
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setLoading(let loading):
            newState.loading = loading
        case .requestCommunityList(let communityLIst):
            newState.communityList = communityLIst
        }
        
        return newState
    }
}

// MARK: - Custom Methods

extension CommunityMainReactor {
    private func requestCommunityListRx() -> Observable<Mutation> {
        return Observable.create { observer in
            let dummyCommunityList = [
                CommunityPostList(category: "자유", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "닉"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
                CommunityPostList(category: "자유", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "네"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
                CommunityPostList(category: "자유", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "임"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
                CommunityPostList(category: "자유", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "slr"), like: Like(isLiked: true, likeCount: 1), commentCount: 1)
            ].shuffled()
            observer.onNext(Mutation.requestCommunityList(communityLIst: dummyCommunityList))
            observer.onCompleted()
            return Disposables.create()
        }.delay(.seconds(2), scheduler: MainScheduler.instance)
    }
}

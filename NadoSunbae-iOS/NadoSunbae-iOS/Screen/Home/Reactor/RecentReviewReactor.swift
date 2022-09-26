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
        case requestRecentReviewList(reviewList: [RecentReviewPostModel])
    }
    
    struct State {
        var loading = false
        var recentReviewList: [RecentReviewPostModel] = []
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

// MARK: - Custom Methods
extension RecentReviewReactor {
    private func requestReviewList() -> Observable<Mutation> {
        return Observable.create { observer in
            let dummyList = [
                RecentReviewPostModel(id: 1, oneLineReview: "난 자유롭고 싶어 지금 전투력 수치 111퍼", majorName: "국어국문학과", createdAt: "21/12/23", tagList: [ReviewTagList(tagName: "추천 수업"), ReviewTagList(tagName: "힘든 수업"), ReviewTagList(tagName: "꿀팁")], like: Like(isLiked: true, likeCount: 3)),
                RecentReviewPostModel(id: 12, oneLineReview: "난 자유롭고 싶어 지금 전투력 수치 111퍼 입고싶은 옷 입고싶어 최대 40자", majorName: "국어국문학과", createdAt: "21/12/23", tagList: [ReviewTagList(tagName: "추천 수업"), ReviewTagList(tagName: "힘든 수업"), ReviewTagList(tagName: "꿀팁")], like: Like(isLiked: false, likeCount: 3)),
                RecentReviewPostModel(id: 32, oneLineReview: "안녕하세요", majorName: "국어국문학과", createdAt: "21/12/23", tagList: [ReviewTagList(tagName: "추천 수업"), ReviewTagList(tagName: "꿀팁")], like: Like(isLiked: false, likeCount: 3)),
                RecentReviewPostModel(id: 11, oneLineReview: "난 자유롭고 싶어 지금 전투력 수치 111퍼 입고싶은 옷 입고싶어 최대 40자", majorName: "국어국문학과", createdAt: "21/12/23", tagList: [ReviewTagList(tagName: "추천 수업"), ReviewTagList(tagName: "힘든 수업"), ReviewTagList(tagName: "꿀팁")], like: Like(isLiked: false, likeCount: 2)),
                RecentReviewPostModel(id: 12, oneLineReview: "난 자유롭고 싶어 지금 전투력 수치 111퍼 입고싶은 옷 입고싶어 최대 40자", majorName: "국어국문학과", createdAt: "21/12/23", tagList: [ReviewTagList(tagName: "꿀팁")], like: Like(isLiked: false, likeCount: 5))
            ]
            
            observer.onNext(Mutation.requestRecentReviewList(reviewList: dummyList))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

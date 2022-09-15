//
//  RecentQuestionTVCReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/14.
//

import Foundation
import ReactorKit

final class RecentQuestionTVCReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: represent user actions
    enum Action {
        case reloadRecentQuestionTV
    }
    
    // MARK: represent state changes
    // Action과 State를 연결, Reactor Layer에만 존재
    enum Mutation {
        case requestRecentQuestionList(questionList: [PostListResModel])
    }
    
    // MARK: represent the current view state
    struct State {
        var questionList: [PostListResModel] = []
    }
    
    init() {
        self.action.onNext(.reloadRecentQuestionTV)
    }
}

// MARK: - Reactor
extension RecentQuestionTVCReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reloadRecentQuestionTV:
            return Observable.concat([
                self.requestRecentQuestionList()
            ])
        }
    }
    
    /// reduce (Mutation -> State)
    /// 최종 State를 View로 방출
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .requestRecentQuestionList(let questionList):
            newState.questionList = questionList
        }
        
        return newState
    }
}

// MARK: - Custom Methods
extension RecentQuestionTVCReactor {
    private func requestRecentQuestionList() -> Observable<Mutation> {
        return Observable.create { observer in
            PublicAPI.shared.getPostList(univID: 1, majorID: 0, filter: .questionToPerson, sort: "recent", search: "") { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? [PostListResModel] {
                        observer.onNext(Mutation.requestRecentQuestionList(questionList: data))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    // ✅ TODO: Alert Display Protocol화 하기
                    if let message = res as? String {
//                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
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
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

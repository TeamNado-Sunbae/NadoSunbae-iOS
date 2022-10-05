//
//  CommunityWriteReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/24.
//

import Foundation
import ReactorKit

final class CommunityWriteReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: represent user actions
    enum Action {
        case loadCategoryData
        case tapQuestionWriteBtn(type: PostFilterType, majorID: Int, answererID: Int, title: String, content: String)
        case tapQuestionEditBtn(postID: Int, title: String, content: String)
    }
    
    // MARK: represent state changes
    enum Mutation {
        case setLoading(loading: Bool)
        case setCategoryData(data: [String])
        case setSuccess(success: Bool)
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var categoryData: [String] = []
        var writePostSuccess: Bool = false
    }
}

// MARK: - Reactor

extension CommunityWriteReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadCategoryData:
            return Observable.concat(Observable.just(.setCategoryData(data: ["자유", "질문", "정보"])))
        case .tapQuestionWriteBtn(let type, let majorID, let answererID, let title, let content):
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestWritePost(type: type, majorID: majorID, answererID: answererID, title: title, content: content),
                Observable.just(.setLoading(loading: false))
            ])
        case .tapQuestionEditBtn(let postID, let title, let content):
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestEditPost(postID: postID, title: title, content: content),
                Observable.just(.setLoading(loading: false))
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
        case .setCategoryData(let data):
            newState.categoryData = data
        case .setSuccess(let success):
            newState.writePostSuccess = success
        }
        
        return newState
    }
}

// MARK: - Custom Methods
extension CommunityWriteReactor {
    
    /// 게시글 작성 API를 연결하는 메서드
    private func requestWritePost(type: PostFilterType, majorID: Int, answererID: Int, title: String, content: String)  -> Observable<Mutation> {
        return Observable.create { observer in
            PublicAPI.shared.requestWritePost(type: type, majorID: majorID, answererID: answererID, title: title, content: content) { networkResult in
                switch networkResult {
                case .success(let res):
                    if let _ = res as? WritePostResModel {
                        observer.onNext(Mutation.setSuccess(success: true))
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
    
    /// 글 수정 API 호출 메서드
    private func requestEditPost(postID: Int, title: String, content: String) -> Observable<Mutation> {
        return Observable.create { observer in
            PublicAPI.shared.editPostAPI(postID: postID, title: title, content: content) { networkResult in
                switch networkResult {
                case .success(_):
                    observer.onNext(Mutation.setSuccess(success: true))
                    observer.onNext(Mutation.setLoading(loading: false))
                    observer.onCompleted()
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

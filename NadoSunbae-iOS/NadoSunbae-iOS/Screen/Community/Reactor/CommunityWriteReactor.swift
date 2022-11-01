//
//  CommunityWriteReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/24.
//

import Foundation
import ReactorKit
import FirebaseAnalytics

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
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
        case setUpdateAccessTokenAction(action: Action)
        case setUpdateAccessTokenState(state: Bool)
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var categoryData: [String] = []
        var writePostSuccess: Bool = false
        var showAlert: Bool = false
        var alertMessage: String = ""
        var isUpdateAccessToken: Bool = false
        var reRequestAction: Action = .tapQuestionWriteBtn(type: .community, majorID: 0, answererID: 0, title: "", content: "")
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
            if success {
                newState.loading = false
            }
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
extension CommunityWriteReactor {
    
    /// 게시글 작성 API를 연결하는 메서드
    private func requestWritePost(type: PostFilterType, majorID: Int, answererID: Int, title: String, content: String)  -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            PublicAPI.shared.requestWritePost(type: type, majorID: majorID, answererID: answererID, title: title, content: content) { networkResult in
                switch networkResult {
                case .success(let res):
                    if let _ = res as? WritePostResModel {
                        observer.onNext(Mutation.setSuccess(success: true))
                        self?.sendEvent(eventName: .community_write, parameterValue: type.postWriteLogEventParameterValue)
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.setUpdateAccessTokenAction(action: .tapQuestionWriteBtn(type: type, majorID: majorID, answererID: answererID, title: title, content: content)))
                        observer.onNext(Mutation.setUpdateAccessTokenState(state: true))
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
    
    /// 글 수정 API 호출 메서드
    private func requestEditPost(postID: Int, title: String, content: String) -> Observable<Mutation> {
        return Observable.create { observer in
            PublicAPI.shared.editPostAPI(postID: postID, title: title, content: content) { networkResult in
                switch networkResult {
                case .success(_):
                    observer.onNext(Mutation.setSuccess(success: true))
                    observer.onCompleted()
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.setUpdateAccessTokenAction(action: .tapQuestionEditBtn(postID: postID, title: title, content: content)))
                        observer.onNext(Mutation.setUpdateAccessTokenState(state: true))
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

// MARK: - SendGAEventDelegate
extension CommunityWriteReactor: SendGAEventDelegate {
    
    /// Analytics Event를 보내는 메서드
    func sendEvent(eventName: GAEventNameType, parameterValue: String) {
        FirebaseAnalytics.Analytics.logEvent("\(eventName)", parameters: [eventName.parameterName : parameterValue])
    }
}

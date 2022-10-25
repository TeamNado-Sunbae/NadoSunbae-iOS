//
//  PersonalQuestionReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/08.
//

import Foundation
import ReactorKit

final class PersonalQuestionReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: Action
    enum Action {
        case reloadAvailableSeniorListCV
        case reloadRecentQuestionListTV
    }
    
    // MARK: Mutation
    enum Mutation {
        case setLoading(loading: Bool)
        case requestSeniorList(seniorList: [QuestionUser])
        case requestRecentQuestionList(recentQuestionList: [PostListResModel])
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
        case updateAccessToken(state: Bool, action: Action)
    }
    
    // MARK: State
    struct State {
        var loading: Bool = false
        var seniorList: [QuestionUser] = []
        var recentQuestionList: [PostListResModel] = []
        var showAlert: Bool = false
        var alertMessage: String = ""
        var isUpdateAccessToken: Bool = false
        var reloadAction: Action = .reloadAvailableSeniorListCV
    }
}

// MARK: - Reactor
extension PersonalQuestionReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reloadAvailableSeniorListCV:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                requestSeniorList()])
        case .reloadRecentQuestionListTV:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                requestRecentQuestionList()])
        }
    }
    
    /// reduce (Mutation -> State)
    /// 최종 State를 View로 방출
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let loading):
            newState.loading = loading
        case .requestSeniorList(let seniorList):
            newState.seniorList = seniorList
        case .requestRecentQuestionList(let recentQuestionList):
            newState.recentQuestionList = recentQuestionList
        case .setAlertState(let showState, let message):
            newState.showAlert = showState
            newState.alertMessage = message
        case .updateAccessToken(let state, let action):
            newState.isUpdateAccessToken = state
            newState.reloadAction = action
        }
        
        return newState
    }
}

// MARK: - Custom Methods
extension PersonalQuestionReactor {
    private func requestRecentQuestionList() -> Observable<Mutation> {
        return Observable.create { observer in
            let majorID = MajorInfo.shared.selectedMajorID ?? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID)
            PublicAPI.shared.getPostList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), majorID: majorID, filter: .questionToPerson, sort: "recent", search: "") { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? [PostListResModel] {
                        observer.onNext(Mutation.requestRecentQuestionList(recentQuestionList: data))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.updateAccessToken(state: true, action: .reloadRecentQuestionListTV))
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
    
    private func requestSeniorList() -> Observable<Mutation> {
        return Observable.create { observer in
            let majorID = MajorInfo.shared.selectedMajorID ?? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID)
            ClassroomAPI.shared.getMajorUserListAPI(majorID: majorID, isExclude: false) { networkResult in
                switch networkResult {
                case .success(let res):
                    if let data = res as? MajorUserListDataModel {
                        var questionUserList = data.onQuestionUserList
                        if questionUserList.count > 8 {
                            questionUserList = Array(data.onQuestionUserList.suffix(from: 8))
                            questionUserList.append(QuestionUser())
                        }
                        observer.onNext(Mutation.requestSeniorList(seniorList: questionUserList))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.updateAccessToken(state: true, action: .reloadAvailableSeniorListCV))
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

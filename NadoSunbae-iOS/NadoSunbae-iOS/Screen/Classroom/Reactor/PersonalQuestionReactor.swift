//
//  PersonalQuestionReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/08.
//

import Foundation
import ReactorKit

enum PersonalQuestionLoadingItem {
    case seniorList
    case recentQuestionList
}

final class PersonalQuestionReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: Action
    enum Action {
        case reloadAvailableSeniorListCV
        case reloadRecentQuestionListTV
    }
    
    // MARK: Mutation
    enum Mutation {
        case setLoading(loading: Bool, item: PersonalQuestionLoadingItem)
        case requestSeniorList(seniorList: [QuestionUser])
        case requestRecentQuestionList(recentQuestionList: [PostListResModel])
        case setAlertState(showState: Bool, message: String = AlertType.networkError.alertMessage)
        case setUpdateAccessTokenAction(action: Action)
        case setUpdateAccessToken(state: Bool, item: PersonalQuestionLoadingItem)
    }
    
    // MARK: State
    struct State {
        var loading: [Bool] = [false, false]
        var seniorList: [QuestionUser] = []
        var recentQuestionList: [PostListResModel] = []
        var showAlert: Bool = false
        var alertMessage: String = ""
        var isUpdateAccessToken: [Bool] = [false, false]
        var reRequestAction: [Action] = []
    }
}

// MARK: - Reactor
extension PersonalQuestionReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reloadAvailableSeniorListCV:
            return Observable.concat([
                Observable.just(.setLoading(loading: true, item: .seniorList)),
                requestSeniorList()])
        case .reloadRecentQuestionListTV:
            return Observable.concat([
                Observable.just(.setLoading(loading: true, item: .recentQuestionList)),
                requestRecentQuestionList()])
        }
    }
    
    /// reduce (Mutation -> State)
    /// 최종 State를 View로 방출
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let loading, let item):
            switch item {
                
            case .seniorList:
                newState.loading[0] = loading
            case .recentQuestionList:
                newState.loading[1] = loading
            }
        case .requestSeniorList(let seniorList):
            newState.seniorList = seniorList
            newState.reRequestAction = newState.reRequestAction.filter({ $0 != .reloadAvailableSeniorListCV })
        case .requestRecentQuestionList(let recentQuestionList):
            newState.recentQuestionList = recentQuestionList.isEmpty ? makeEmptyPostListResModel() : recentQuestionList
            newState.reRequestAction = newState.reRequestAction.filter({ $0 != .reloadRecentQuestionListTV })
        case .setAlertState(let showState, let message):
            newState.showAlert = showState
            newState.alertMessage = message
        case .setUpdateAccessTokenAction(let action):
            newState.reRequestAction.append(action)
        case .setUpdateAccessToken(let state, let item):
            switch item {
                
            case .seniorList:
                newState.isUpdateAccessToken[0] = state
            case .recentQuestionList:
                newState.isUpdateAccessToken[1] = state
            }
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
                        observer.onNext(Mutation.setLoading(loading: false, item: .recentQuestionList))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false, item: .recentQuestionList))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.setUpdateAccessTokenAction(action: .reloadRecentQuestionListTV))
                        observer.onNext(Mutation.setUpdateAccessToken(state: true, item: .recentQuestionList))
                    }
                default:
                    observer.onNext(Mutation.setAlertState(showState: true))
                    observer.onNext(Mutation.setLoading(loading: false, item: .recentQuestionList))
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
                            questionUserList = Array(data.onQuestionUserList.prefix(upTo: 8))
                            questionUserList.append(QuestionUser())
                        }
                        observer.onNext(Mutation.requestSeniorList(seniorList: questionUserList))
                        observer.onNext(Mutation.setLoading(loading: false, item: .seniorList))
                        observer.onCompleted()
                    }
                case .requestErr(let res):
                    if let _ = res as? String {
                        observer.onNext(Mutation.setAlertState(showState: true))
                        observer.onNext(Mutation.setLoading(loading: false, item: .seniorList))
                        observer.onCompleted()
                    } else if res is Bool {
                        observer.onNext(.setUpdateAccessTokenAction(action: .reloadAvailableSeniorListCV))
                        observer.onNext(Mutation.setUpdateAccessToken(state: true, item: .seniorList))
                    }
                default:
                    observer.onNext(Mutation.setAlertState(showState: true))
                    observer.onNext(Mutation.setLoading(loading: false, item: .seniorList))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    private func makeEmptyPostListResModel() -> [PostListResModel] {
        return [PostListResModel(postID: -1, type: "", title: "", content: "", createdAt: "", majorName: "", writer: CommunityWriter(writerID: 0, nickname: ""), isAuthorized: false, commentCount: 0, like: Like(isLiked: false, likeCount: 0))]
    }
}

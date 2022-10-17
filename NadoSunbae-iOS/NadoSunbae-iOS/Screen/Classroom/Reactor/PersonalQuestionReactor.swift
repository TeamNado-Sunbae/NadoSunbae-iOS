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
    }
    
    // MARK: State
    struct State {
        var loading: Bool = false
        var seniorList: [QuestionUser] = []
        var recentQuestionList: [PostListResModel] = []
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
                    // ✅ TODO: Alert Display Protocol화 하기
                    if let _ = res as? String {
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
                    // ✅ TODO: Alert Display Protocol화 하기
                    if let _ = res as? String {
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

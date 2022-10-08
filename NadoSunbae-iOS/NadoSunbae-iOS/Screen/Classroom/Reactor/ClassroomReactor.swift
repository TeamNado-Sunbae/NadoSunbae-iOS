//
//  ClassroomReactor.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/07.
//

import Foundation
import ReactorKit

final class ClassroomReactor: Reactor {
    
    var initialState: State = State()
    
    // MARK: Action
    enum Action {
        case filterBtnDidTap
        case arrangeBtnDidTap
    }
    
    // MARK: Mutation
    enum Mutation {
        case setLoading(loading: Bool)
        case setFilterBtnState(selected: Bool)
        case setArrangeBtnState(arrange: String)
    }
    
    // MARK: State
    struct State {
        var loading: Bool = false
        var filterBtnSelected: Bool = false
        var arrangeString: String = ""
    }
}

// MARK: - Reactor
extension ClassroomReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterBtnDidTap:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                Observable.just(.setLoading(loading: false))
            ])
        case .arrangeBtnDidTap:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
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
        case .setFilterBtnState(let selected):
            newState.filterBtnSelected = selected
        case .setArrangeBtnState(let arrange):
            newState.arrangeString = arrange
        }
        
        return newState
    }
}

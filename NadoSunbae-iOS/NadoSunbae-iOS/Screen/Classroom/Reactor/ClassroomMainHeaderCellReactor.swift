//
//  ClassroomMainHeaderCellReactor..swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/08/20.
//

import ReactorKit

class ClassroomMainHeaderCellReactor: Reactor {
    let initialState = State()
    
    // MARK: Action
    enum Action {
        case tapFilterBtn
        case tapArrangeBtn
    }
    
    // MARK: Mutation
    enum Mutation {
        case setFilterBtnSelection(Bool)
        case setArrangeBtnSelection(Bool)
    }
    
    // MARK: State
    struct State {
        var isFilterBtnSelected = false
        var isArrangeBtnSelected = false
    }
}

extension ClassroomMainHeaderCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapFilterBtn:
            let btnState = currentState.isFilterBtnSelected ? false : true
            return Observable.concat(Observable.just(.setFilterBtnSelection(btnState)))
        case .tapArrangeBtn:
            let btnState = currentState.isArrangeBtnSelected ? false : true
            return Observable.concat(Observable.just(.setArrangeBtnSelection(btnState)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setFilterBtnSelection(let isSelected):
            newState.isFilterBtnSelected = isSelected
        case .setArrangeBtnSelection(let isSelected):
            newState.isArrangeBtnSelected = isSelected
        }
        return newState
    }
}

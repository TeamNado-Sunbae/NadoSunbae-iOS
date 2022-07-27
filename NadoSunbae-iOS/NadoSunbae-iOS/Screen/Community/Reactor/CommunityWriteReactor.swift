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
        case majorSelectBtnDidTap
        case loadCategoryData
    }
    
    // MARK: represent state changes
    enum Mutation {
        case setLoading(loading: Bool)
        case printText(text: String)
        case setCategoryData(data: [String])
    }
    
    // MARK: represent the current view state
    struct State {
        var loading: Bool = false
        var printedText: String = ""
        var categoryData: [String] = []
    }
}

// MARK: - Reactor

extension CommunityWriteReactor {
    
    /// mutate (Action -> Mutation)
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .majorSelectBtnDidTap:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                Observable.just(.printText(text: "학과선택 버튼 클릭")),
                Observable.just(.setLoading(loading: false))
            ])
        case .loadCategoryData:
            return Observable.concat(Observable.just(.setCategoryData(data: ["자유", "질문", "정보"])))
        }
    }
    
    /// reduce (Mutation -> State)
    /// 최종 State를 View로 방출
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setLoading(let loading):
            newState.loading = loading
        case .printText(let text):
            newState.printedText = text
        case .setCategoryData(let data):
            newState.categoryData = data
        }
        
        return newState
    }
}

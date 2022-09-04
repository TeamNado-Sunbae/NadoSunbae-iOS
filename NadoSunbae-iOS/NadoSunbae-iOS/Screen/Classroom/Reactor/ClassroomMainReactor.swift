//
//  ClassroomMainReactor.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/08/13.
//

import UIKit
import ReactorKit

final class ClassroomMainReactor: Reactor {
    
    let initialState: State
    
    enum CellType {
        case imageCell
        case reviewPostCell(ReviewPostModel)
    }
    
    // MARK: Action
    enum Action {
        case tapFilterBtn
        case tapArrangeBtn
    }
    
    // MARK: Mutation
    enum Mutation {
        case setLoading(loading: Bool)
        case setFilterBtnSelection(Bool)
        case setArrangeBtnSelection(Bool)
    }
    
    // MARK: State
    struct State {
        var sections: [ClassroomMainSection]
        var loading = false
        var isFilterBtnSelected = false
        var isArrangeBtnSelected = false
    }
    
    // MARK: init
    init() {
        self.initialState = State(sections: ClassroomMainReactor.configureSections())
    }
}

// MARK: - Reactor
extension ClassroomMainReactor {
    
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
        case .setLoading(let loading):
            newState.loading = loading
        case .setFilterBtnSelection(let isSelected):
            newState.isFilterBtnSelected = isSelected
        case .setArrangeBtnSelection(let isSelected):
            newState.isArrangeBtnSelected = isSelected
        }
        return newState
    }
    
    static func configureSections() -> [ClassroomMainSection] {
        let imageCell = ClassroomMainSectionItem.imageCell
        let reviewPostCell1 = ClassroomMainSectionItem.reviewPostCell(ReviewPostCellReactor(state: ReviewPostModel(postId: 1, title: "안녕하세요안녕하세요안녕하세요", createdAt: "22/08/14", writer: ReviewPostModel.Writer(writerId: 1, profileImageId: 1, nickname: "은주"), like: ReviewPostModel.Like(isLiked: true, likeCount: 2))))
        let reviewPostCell2 = ClassroomMainSectionItem.reviewPostCell(ReviewPostCellReactor(state: ReviewPostModel(postId: 1, title: "더미데이터 입니당", createdAt: "22/08/15", writer: ReviewPostModel.Writer(writerId: 1, profileImageId: 1, nickname: "지은"), like: ReviewPostModel.Like(isLiked: false, likeCount: 3))))
        let reviewPostCell3 = ClassroomMainSectionItem.reviewPostCell(ReviewPostCellReactor(state: ReviewPostModel(postId: 1, title: "아요드라 사랑해", createdAt: "22/08/16", writer: ReviewPostModel.Writer(writerId: 1, profileImageId: 1, nickname: "정빈"), like: ReviewPostModel.Like(isLiked: true, likeCount: 3))))
        let reviewPostCell4 = ClassroomMainSectionItem.reviewPostCell(ReviewPostCellReactor(state: ReviewPostModel(postId: 1, title: "MVVM개어렵다...", createdAt: "22/08/17", writer: ReviewPostModel.Writer(writerId: 1, profileImageId: 1, nickname: "리액터은주"), like: ReviewPostModel.Like(isLiked: false, likeCount: 3))))
        let imageSection = ClassroomMainSection.imageSection([imageCell])
        let reviewPostSection = ClassroomMainSection.reviewPostSection([reviewPostCell1, reviewPostCell2, reviewPostCell3, reviewPostCell4])
        
        return [imageSection, reviewPostSection]
    }
}

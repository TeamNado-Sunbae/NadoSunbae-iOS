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
        case tapReviewSegment
        case tapQuestionSegment
    }
    
    // MARK: Mutation
    enum Mutation {
        case setLoading(loading: Bool)
        case setFilterBtnSelection(Bool)
        case setArrangeBtnSelection(Bool)
        case setClassroomMainTV(type: Int)
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
        self.initialState = State(sections: ClassroomMainReactor.configureSections(type: 0))
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
        case .tapReviewSegment:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                Observable.just(.setClassroomMainTV(type: 0)).delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(loading: false))
            ])
        case .tapQuestionSegment:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                Observable.just(.setClassroomMainTV(type: 1)).delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(loading: false))
            ])
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
        case .setClassroomMainTV(let type):
            newState = State(sections: ClassroomMainReactor.configureSections(type: type))
        }
        return newState
    }
    
    static func configureSections(type: Int) -> [ClassroomMainSection] {
        let imageCell = ClassroomMainSectionItem.imageCell
        let reviewPostCell1 = ClassroomMainSectionItem.reviewPostCell(ReviewPostModel(postId: 1, title: "안녕하세요안녕하세요안녕하세요", createdAt: "22/08/15", writer: ReviewPostModel.Writer(writerId: 1, profileImageId: 1, nickname: "지은"), like: ReviewPostModel.Like(isLiked: false, likeCount: 3), tagList: [ReviewTagList(tagName: "추천 수업")]))
        let reviewPostCell2 = ClassroomMainSectionItem.reviewPostCell(ReviewPostModel(postId: 2, title: "더미데이터 입니당", createdAt: "22/08/15", writer: ReviewPostModel.Writer(writerId: 1, profileImageId: 1, nickname: "은주"), like: ReviewPostModel.Like(isLiked: true, likeCount: 3), tagList: [ReviewTagList(tagName: "추천 수업"), ReviewTagList(tagName: "힘든 수업")]))
        let reviewPostCell3 = ClassroomMainSectionItem.reviewPostCell(ReviewPostModel(postId: 3, title: "MVVM개어렵다...", createdAt: "22/08/15", writer: ReviewPostModel.Writer(writerId: 1, profileImageId: 1, nickname: "정빈"), like: ReviewPostModel.Like(isLiked: false, likeCount: 3), tagList: [ReviewTagList(tagName: "추천 수업")]))
        let questionCell = ClassroomMainSectionItem.questionCell
        
        let imageSection = ClassroomMainSection.imageSection([imageCell])
        let reviewPostSection = ClassroomMainSection.reviewPostSection([reviewPostCell1, reviewPostCell2, reviewPostCell3])
        let questionSection = ClassroomMainSection.questionPostSection([questionCell])
        
        if type == 0 {
            return [imageSection, reviewPostSection]
        } else {
            return [imageSection, questionSection]
        }
    }
}

//
//  ReviewPostCellReactor.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/08/14.
//

import ReactorKit

class ReviewPostCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: ReviewPostModel
    
    init(state: ReviewPostModel) {
        self.initialState = state
    }
}

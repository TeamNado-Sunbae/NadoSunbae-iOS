//
//  ClassroomService.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/19.
//

import Foundation
import Moya

enum ClassroomService {
    case getQuestionDetail(chatPostID: Int)
}

extension ClassroomService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .getQuestionDetail(let chatPostID):
            return "/classroom-post/question/\(chatPostID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getQuestionDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
            
        case .getQuestionDetail:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let accessToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken) ?? ""
        
        switch self {
            
        case .getQuestionDetail:
            return ["accesstoken" : accessToken]
        }
    }
}

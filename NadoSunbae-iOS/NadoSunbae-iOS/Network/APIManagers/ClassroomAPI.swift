//
//  ClassroomAPI.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/19.
//

import Foundation
import Moya

class ClassroomAPI {
    static let shared = ClassroomAPI()
    var userProvider = MoyaProvider<ClassroomService>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    /// [GET] 1:1질문, 전체 질문 상세 조회 API 메서드
    func getQuestionDetailAPI(chatPostID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.getQuestionDetail(chatPostID: chatPostID)) { [self] result in
            switch result {
            
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(getQuestionDetaiJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
}

// MARK: - JudgeData
extension ClassroomAPI {
    
    /// 1:1질문, 전체 질문 상세 조회
    func getQuestionDetaiJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<ClassroomQuestionDetailData>.self, from: data) else {
            return .pathErr }
        
        switch status {
        case 200:
            return .success(decodedData.data.self as Any)
        case 400...500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}

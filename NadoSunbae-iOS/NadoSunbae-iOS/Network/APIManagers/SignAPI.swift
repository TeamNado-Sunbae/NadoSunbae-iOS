//
//  SignAPI.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation
import Moya

class SignAPI {
    static let shared = SignAPI()
    private var provider = MoyaProvider<SignService>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
}

// MARK: - API
extension SignAPI {
    
    /// [POST] 로그인 요청
    func signIn(email: String, PW: String, deviceToken: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.signIn(email: email, PW: PW, deviceToken: deviceToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.signInJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 회원가입 요청
    func signUp(userData: SignUpBodyModel, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.signUp(userData: userData)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.signUpJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 닉네임 중복 확인 요청
    func checkNickNameDuplicate(nickName: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.checkNickNameDuplicate(nickName: nickName)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.checkNickNameDuplicateJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

// MARK: - judgeData
extension SignAPI {
    private func signInJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<SignInDataModel>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data ?? "None-Data")
        case 400...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func signUpJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<SignUpDataModel>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data ?? "None-Data")
        case 400...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func checkNickNameDuplicateJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data ?? "None-Data")
        case 400...408:
            return .requestErr(decodedData.message)
        case 409:
            return .requestErr(false)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}

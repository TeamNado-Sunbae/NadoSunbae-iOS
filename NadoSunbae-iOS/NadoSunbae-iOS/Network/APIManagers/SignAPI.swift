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
    private var provider = MoyaProvider<SignService>()
    
    private init() {}
}

// MARK: - API
extension SignAPI {
    
    /// [POST] 로그인 요청
    func requestSignIn(email: String, PW: String, deviceToken: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestSignIn(email: email, PW: PW, deviceToken: deviceToken)) { result in
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
    func requestSignUp(userData: SignUpBodyModel, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestSignUp(userData: userData)) { result in
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
    
    /// [POST] 이메일 중복 확인 요청
    func checkEmailDuplicate(email: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.checkEmailDuplicate(email: email)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.checkEmailDuplicateJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 로그아웃 요청
    func requestSignOut(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestSignOut) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.signOutJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 회원탈퇴 요청
    func requestWithDraw(PW: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestWithDraw(PW: PW)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.withDrawJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 로그인 요청
    func resendSignUpMail(email: String, PW: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.resendSignUpMail(email: email, PW: PW)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.resendSignUpMailJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 토큰 갱신, 자동로그인
    func updateToken(refreshToken: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.updateToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.updateTokenJudgeData(status: statusCode, data: data))
                
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
        case 200, 201, 203, 204:
            return .success(decodedData.data ?? "None-Data")
        case 202:
            return .requestErr(false)
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
    
    private func checkEmailDuplicateJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
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
    
    private func signOutJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(SignOutResponseModel.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.message)
        case 401:
            return .requestErr(false)
        case 400, 402...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func withDrawJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<WithDrawResponseModel>.self, from: data) else { return .pathErr }
        switch status {
        case 200...204:
            return .success(decodedData.message)
        case 400...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func resendSignUpMailJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<ResendSignUpMailResponseModel>.self, from: data) else { return .pathErr }
        switch status {
        case 200...204:
            return .success(decodedData.message)
        case 400...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func updateTokenJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
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
}

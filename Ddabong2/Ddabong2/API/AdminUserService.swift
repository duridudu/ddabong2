//
//  AdminUserService.swift
//  Ddabong2
//
//  Created by 안지희 on 1/13/25.
//


import Alamofire

class AdminUserService {
    /*
    static let shared = AdminUserService()
    private let baseURL = "https://myhands.store"

    private init() {}

    // 아이디 중복 확인
    func checkDuplicateID(id: String, completion: @escaping (Result<Bool, String>) -> Void) {
        let url = "\(baseURL)/user/duplicate"
        let parameters: [String: String] = ["id": id]

        AF.request(url, method: .get, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let status = json["status"] as? String,
                       status == "OK" {
                        completion(.success(true)) // 중복 없음
                    } else {
                        completion(.failure("중복 확인 실패: 응답 형식 오류"))
                    }
                case .failure(let error):
                    if let data = response.data,
                       let errorJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = errorJSON["message"] as? String {
                        completion(.failure(message)) // 서버에서 반환된 에러 메시지
                    } else {
                        completion(.failure(error.localizedDescription))
                    }
                }
            }
    }

    // 회원 생성
    func createUser(
        name: String,
        id: String,
        password: String,
        joinedAt: String,
        departmentId: Int,
        jobGroup: Int,
        group: String,
        completion: @escaping (Result<String, String>) -> Void
    ) {
        let url = "\(baseURL)/user/join"
        let parameters: [String: Any] = [
            "name": name,
            "id": id,
            "password": password,
            "joinedAt": joinedAt,
            "departmentId": departmentId,
            "jobGroup": jobGroup,
            "group": group
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let status = json["status"] as? String,
                       status == "CREATED" {
                        completion(.success("회원 생성 성공"))
                    } else {
                        completion(.failure("회원 생성 실패: 응답 형식 오류"))
                    }
                case .failure(let error):
                    if let data = response.data,
                       let errorJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = errorJSON["message"] as? String {
                        completion(.failure(message))
                    } else {
                        completion(.failure(error.localizedDescription))
                    }
                }
            }
    }
     */
}

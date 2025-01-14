//
//  PasswordService.swift
//  Ddabong2
//
//  Created by 안지희 on 1/14/25.
//


import Foundation

class PasswordService {
    static let shared = PasswordService()

    private init() {}

    func changePassword(newPassword: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://myhands.store/user/password") else {
            completion(false, "잘못된 URL입니다.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer <token>", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["password": newPassword]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "네트워크 오류: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, nil)
                } else {
                    let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    completion(false, "서버 오류: \(errorMessage)")
                }
            } else {
                completion(false, "알 수 없는 서버 응답입니다.")
            }
        }

        task.resume()
    }
}

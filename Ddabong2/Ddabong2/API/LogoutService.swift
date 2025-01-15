//
//  LogoutService.swift
//  Ddabong2
//
//  Created by 안지희 on 1/14/25.
//


import Alamofire

class LogoutService {
    static let shared = LogoutService()
    
    private init() {}
    
    func logoutUser(completion: @escaping (Bool) -> Void) {
        let url = "https://myhands.store/user/logout"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]
        
        AF.request(url, method: .delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any], json["status"] as? String == "OK" {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
}

//
//  RankingService.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//


import Alamofire

class RankingService {
    static let shared = RankingService()

    private init() {}

    func fetchRankings(completion: @escaping (Result<RankingResponseDto, Error>) -> Void) {
        let url = "https://myhands.store/exp/rank"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]

        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: RankingResponse.self) { response in
                switch response.result {
                case .success(let rankingResponse):
                    completion(.success(rankingResponse.responseDto))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

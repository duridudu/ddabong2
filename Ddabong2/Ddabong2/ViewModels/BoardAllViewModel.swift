//
//  BoardAllViewModel.swift
//  Ddabong2
//
//  Created by 안지희 on 1/12/25.
//


import Alamofire

class BoardAllViewModel {
    private var boards: [Board] = []
    var onBoardsUpdated: (() -> Void)?

    func fetchAllBoards(size: Int, lastId: Int?) {
        let url = "https://myhands.store/board/list"
        var parameters: [String: Any] = ["size": size]
        if let lastId = lastId {
            parameters["lastId"] = lastId
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]

        print("API 호출 시작")
        print("요청 URL: \(url)")
        print("요청 파라미터: \(parameters)")
        print("요청 헤더: \(headers)")

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: BoardResponse.self) { response in
                switch response.result {
                case .success(let boardResponse):
                    self.boards.append(contentsOf: boardResponse.responseDto)
                    print("API 응답 성공: \(self.boards)")
                    self.onBoardsUpdated?()
                case .failure(let error):
                    print("API 요청 실패: \(error.localizedDescription)")
                }
            }
    }

    func getBoards() -> [Board] {
        return boards
    }
}

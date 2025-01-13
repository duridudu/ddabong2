//JH
//API 호출
//데이터 가져오기~~~

import Alamofire
import UIKit

class BoardViewModel {
    private var boards: [Board] = [] // 게시글 데이터 저장
    var onBoardsUpdated: (() -> Void)? // 데이터 업데이트 콜백

    func fetchBoards(size: Int) {
        print("API 호출 시작")
        let url = "https://myhands.store/board/overview"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "토큰 없음")"
        ]
        print("ACCESS TOKEN",UserSessionManager.shared.getAccessToken())
        let parameters: [String: Any] = ["size": size]
        print("요청 URL: \(url)")
        print("요청 헤더: \(headers)")
        print("요청 파라미터: \(parameters)")

        // API 요청 및 응답 처리
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: BoardResponse.self) { response in
                switch response.result {
                case .success(let boardResponse):
                    self.boards = boardResponse.responseDto.sorted(by: { $0.timeAgo > $1.timeAgo }) // 최신순 정렬
                    print("디코딩 성공: \(self.boards)")
                    self.onBoardsUpdated?() // 데이터 변경 시 콜백 호출
                case .failure(let error):
                    print("디코딩 실패: \(error.localizedDescription)")
                }
            }
    }

    func getBoards() -> [Board] {
        return boards
    }
}

//
//  BoardViewModel.swift
//  Ddabong2
//
//  Created by 안지희 on 1/7/25.
//


import Foundation
import Alamofire

import Foundation

class BoardViewModel {
    var boards: [Board] = []
    var onBoardsFetched: (() -> Void)? // 데이터가 로드된 후 호출
    var onError: ((String) -> Void)? // 에러 발생 시 호출

    func fetchBoards() {
        // 테스트 데이터 추가
        boards = [
            Board(boardId: 1, title: "2025년 사내 교육 일정 공지", createdAt: "2024-12-31 15:00:00"),
            Board(boardId: 2, title: "박민수 차장 장남 결혼식 안내", createdAt: "2024-12-31 13:20:00"),
            Board(boardId: 3, title: "윤호진 부장 장녀 돌잔치 안내", createdAt: "2024-12-30 16:00:00"),
            Board(boardId: 4, title: "2024년 하반기 실적 발표 공지", createdAt: "2024-12-30 14:00:00"),
            Board(boardId: 5, title: "연말 회식 장소 및 시간 공지", createdAt: "2024-12-29 18:00:00")
        ]

        // 데이터를 로드한 후 클로저 호출
        DispatchQueue.main.async {
            self.onBoardsFetched?()
        }
    }
}



    /*
    func fetchBoards() {
        //이 서버 주소는 수정 필요?
        let url = "https://myhands.store/api/board"

        AF.request(url, method: .get).responseDecodable(of: BoardResponse.self) { response in
            switch response.result {
            case .success(let boardResponse):
                if boardResponse.status == "OK" {
                    self.boards = boardResponse.responseDto.boardList
                    self.onBoardsFetched?()
                } else {
                    self.onError?("Failed to fetch boards")
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    */


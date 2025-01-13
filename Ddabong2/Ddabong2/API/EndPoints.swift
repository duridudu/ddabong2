//
//  EndPoints.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/1/25.
//

enum Endpoints {
    static let baseURL = "https://myhands.store"
    
    enum User {
        static let login = "\(baseURL)/user/login"
        static let userInfo = "\(baseURL)/user/info"
        static let update = "\(baseURL)/user/{id}"
        static let delete = "\(baseURL)/user/{id}"
    }
    
    
    // 챗지피티가 만들어줌, 수정필요
    enum Quest{
        static let fetchQuestStats = "\(baseURL)/quest/stats"
        static let update = "\(baseURL)/schedule/{id}"
        static let delete = "\(baseURL)/schedule/{id}"
    }
    
    enum Dayoff {
        static let create = "\(baseURL)/dayoff"
        static let fetch = "\(baseURL)/dayoff/{id}"
        static let update = "\(baseURL)/dayoff/{id}"
        static let delete = "\(baseURL)/dayoff/{id}"
    }
    
    enum Board {
        static let create = "\(baseURL)/board"
        static let fetch = "\(baseURL)/board/{id}"
        static let update = "\(baseURL)/board/{id}"
        static let delete = "\(baseURL)/board/{id}"
    }
}

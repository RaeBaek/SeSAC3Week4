//
//  KakaoAPIManager.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/11.
//

import UIKit
import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoKey)"]
    
    // 탈출 후행 클로저!
    func callRequest(type: Endpoint, query: String, page: Int, completionHandler: @escaping (Video) -> () ) {
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + text + "&page="
        
        print(url)
        
        AF.request(url,
                   method: .get,
                   headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: Video.self) { response in
                
                guard let value = response.value else { return }
                
                completionHandler(value)
                
            }
        
    }
}

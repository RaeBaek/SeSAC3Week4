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
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> () ) {
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + text
        
        print(url)
        
        AF.request(url,
                   method: .get,
                   headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

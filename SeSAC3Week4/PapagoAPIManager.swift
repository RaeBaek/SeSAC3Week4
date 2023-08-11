//
//  PapagoAPIManager.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class PapagoAPIManager {
    
    static let shared = PapagoAPIManager()
    
    private init() { }
    
    func callRequest(text: String, source: String, target: String, resultString: @escaping (String) -> Void ) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverClientID,
            "X-Naver-Client-Secret" : APIKey.naverClientSecret
        ]
        
        let parameters: Parameters = [
            "source": source,
            "target": target,
            "text": text
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                // 클로저로 넘기는 타이밍을 잘 잡아야한다!! (탈출 클로저)
                resultString(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

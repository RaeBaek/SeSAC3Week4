//
//  VideoViewController.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class VideoViewController: UIViewController {

    var videoList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest()
    }
    
    func callRequest() {
        guard let text = "아이유".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)"
        let header: HTTPHeaders = ["Authorization": "KakaoAK 6bf023f74ff8182b05cc26dff0dc6248"]
        AF.request(url,
                   method: .get,
                   headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json["documents"].arrayValue {
                    let title = item["title"].stringValue
                    self.videoList.append(title)
                }
                print(json)
                print(self.videoList)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

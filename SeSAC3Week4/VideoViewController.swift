//
//  VideoViewController.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/08.
//

import UIKit
import Kingfisher

struct Video {
    let author: String
    let date: String
    let time: Int
    let thumbnail: String
    let title: String
    let link: String
    
    var contents: String {
        return "\(author) | \(time)회\n\(date)"
        
    }
}

/*
 {
             "author": "이지금 [IU Official]",
             "datetime": "2023-07-24T18:00:12.000+09:00",
             "play_time": 3304,
             "thumbnail": "https://search4.kakaocdn.net/argon/138x78_80_pr/8l2zi9P1CUs",
             "title": "[아이유의 팔레트🎨] 뉴진스의 컬러 스위치요 (With 뉴진스) Ep.21",
             "url": "http://www.youtube.com/watch?v=MSQhnXRdECs"
         }
 */

class VideoViewController: UIViewController {
    
    var videoList: [Video] = []
    var page = 1
    var isEnd = false // 현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var videoTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTableView.dataSource = self
        videoTableView.delegate = self
        videoTableView.rowHeight = 120
        videoTableView.prefetchDataSource = self
        
        searchBar.delegate = self
        
    }
    
    func callRequest(query: String, page: Int) {
        
        KakaoAPIManager.shared.callRequest(type: .video, query: query) { json in
            print("=========\(json)")
        }
        
//        AF.request(url,
//                   method: .get,
//                   headers: header).validate(statusCode: 200...500).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//
//                guard let statusCode = response.response?.statusCode else { return print("에러발생!")}
//
//                if statusCode == 200 {
//
//                    self.isEnd = json["meta"]["is_end"].boolValue
//                    print(self.isEnd)
//
//                    for item in json["documents"].arrayValue {
//                        let author = item["author"].stringValue
//                        let date = item["datetime"].stringValue
//                        let time = item["play_time"].intValue
//                        let thumbnail = item["thumbnail"].stringValue
//                        let title = item["title"].stringValue
//                        let link = item["link"].stringValue
//
//                        let data = Video(author: author, date: date, time: time, thumbnail: thumbnail, title: title, link: link)
//                        self.videoList.append(data)
//
//                    }
//                    self.videoTableView.reloadData()
//
//                } else {
//                    print("문제가 발생했어요. 잠시 후 다시 시도해주세요!")
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
}

// UITableViewDataSourcePrefetching: iOS10 이상 사용 가능한 프로토콜, CellForRowAt이 호출되기 전에 먼저 호출 됨.
extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운받는 기능
    // videoList 갯수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인 -> 네트워크 요청 시도
    // page count
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if videoList.count - 1 == indexPath.row && page < 15 && !isEnd {
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
    
    // 취소 기능: 직접 취소하는 기능을 구현해줘야 함!
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        print("====취소 \(indexPaths)")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier) as? VideoTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = videoList[indexPath.row].contents
        
        if let url = URL(string: videoList[indexPath.row].thumbnail) {
            cell.thumbnailImageView.kf.setImage(with: url)
        }
        
        return cell
    }
    
}

extension VideoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        page = 1 // 새로운 검색어이기 때문에 page를 1로 변경
        videoList.removeAll()
        
        guard let query = searchBar.text else { return }
        callRequest(query: query, page: page)
        
    }
}

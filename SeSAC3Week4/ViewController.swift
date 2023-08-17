//
//  ViewController.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var title: String
    var release: String
}

class ViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    var movieList: [Movie] = []
    //codable
    var result: BoxOffice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.rowHeight = 60
        
        indicatorView.isHidden = true
        
    }

    func callRequest(date: String, completionHandler: @escaping (BoxOffice) -> Void) {
        
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        
        AF.request(url, method: .get).validate()
            .responseDecodable(of: BoxOffice.self) { response in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                    
                }
                
            }
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        movieList.removeAll()
        
        // 1. 20220101 -> 8글자
        // 2. 20233333 -> 올바른 날짜
        // 3. 날짜 범주
        guard let date = searchBar.text else { return }
        callRequest(date: date) { result in
            self.result = result
            self.movieTableView.reloadData()
            self.indicatorView.isHidden = true
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.boxOfficeResult.dailyBoxOfficeList.count ?? 0 //movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = result?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        cell.detailTextLabel?.text = result?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].openDt
        
        return cell
    }
    
}

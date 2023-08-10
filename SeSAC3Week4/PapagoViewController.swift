//
//  PapagoViewController.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

enum LangEnum: String, CaseIterable {
    case ko = "한국어"
    case en = "영어"
    case ja = "일본어"
    case zh_CN = "중국어 간체"
    case zh_TW = "중국어 번체"
    case vi = "베트남어"
    case id = "인도네시아어"
    case th = "태국어"
    case de = "독일어"
    case ru = "러시아어"
    case es = "스페인어"
    case it = "이탈리아어"
    case fr = "프랑스어"
    
    enum CodingKeys: String, CodingKey {
        case ko, en, ja, vi, id, th, de, ru, es, it, fr
        case zh_CN = "zh-CN"
        case zh_TW = "ch-TW"
    }
}

class PapagoViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var originalLangTextField: UITextField!
    @IBOutlet var transitionLangTextField: UITextField!
    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var transitionTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
    
    var langList: [String: String] = ["ko": "한국어", "en": "영어", "ja": "일본어", "zh-CN": "중국어 간체", "zh-TW": "중국어 번체", "vi": "베트남어", "id": "인도네시아어", "th": "태국어", "de": "독일어", "ru": "러시아어", "es": "스페인어", "it": "이탈리아어", "fr": "프랑스어"]
    var langList2: [String: String] = ["한국어": "ko", "영어": "en", "일본어": "ja", "중국어 간체": "zh-CN", "중국어 번체": "zh-TW중", "베트남어": "vi", "인도네시아어": "id", "태국어": "th", "독일어": "de", "러시아어": "ru", "스페인어": "es", "이탈리아어": "it", "프랑스어": "fr"]
    var sortedLangDict = [String: String]()
    var values: [String] = []
    
    let originalPickerView = UIPickerView()
    let transitionPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        originalPickerView.delegate = self
        originalPickerView.dataSource = self
        transitionPickerView.delegate = self
        transitionPickerView.dataSource = self
        
        originalLangTextField.inputView = originalPickerView
        transitionLangTextField.inputView = transitionPickerView
        
    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        
        guard let source = originalLangTextField.text else { return }
        guard let target = transitionLangTextField.text else { return }
        
        guard let sourceValue = langList2[source] else { return }
        guard let targetValue = langList2[target] else { return }
        
        requestAPI(source: sourceValue, target: targetValue)
    }
    
    func setUI() {
        titleLabel.text = "원하는 언어로 번역해보세요! with Papago🦜"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center
        
        originalLangTextField.placeholder = "번역할 언어를 선택해주세요."
        
        transitionLangTextField.placeholder = "번역될 언어를 선택해주세요."
        
        originalTextView.layer.borderColor = UIColor.black.cgColor
        originalTextView.layer.borderWidth = 1
        originalTextView.layer.cornerRadius = 5
        
        transitionTextView.layer.borderColor = UIColor.black.cgColor
        transitionTextView.layer.borderWidth = 1
        transitionTextView.layer.cornerRadius = 5
        
        requestButton.layer.borderColor = UIColor.black.cgColor
        requestButton.layer.borderWidth = 1
        requestButton.layer.cornerRadius = 5
        requestButton.setTitle("번역하기", for: .normal)
        requestButton.tintColor = .black
    }
    
    func requestAPI(source: String, target: String) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverClientID,
            "X-Naver-Client-Secret" : APIKey.naverClientSecret
        ]
        guard let text = originalTextView.text else { return }
        let parameters: Parameters = [
            "source": source,
            "target": target,
            "text": text
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                self.transitionTextView.text = data
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension PapagoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return langList2.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let lang = langList2.sorted { $0.0 < $1.0 }
        return lang[row].key
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let lang = langList2.sorted { $0.0 < $1.0 }
        
        if pickerView == originalPickerView {
            originalLangTextField.text = lang[row].key
        } else {
            transitionLangTextField.text = lang[row].key
        }
    }
    
}

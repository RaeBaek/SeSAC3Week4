//
//  PapagoViewController.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/10.
//

import UIKit

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
    
    var languageList: [String: String] = ["한국어": "ko", "영어": "en", "일본어": "ja", "중국어 간체": "zh-CN", "중국어 번체": "zh-TW", "베트남어": "vi", "인도네시아어": "id", "태국어": "th", "독일어": "de", "러시아어": "ru", "스페인어": "es", "이탈리아어": "it", "프랑스어": "fr"]
    
    var sortedLangDict: [Dictionary<String, String>.Element] = []
    
    var values: [String] = []
    
    let originalPickerView = UIPickerView()
    let transitionPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultsHelper.standard.nickname = "래훈"
        UserDefaultsHelper.standard.age
        
        UserDefaults.standard.set("고래밥", forKey: "nickname")
        UserDefaults.standard.set(33, forKey: "age")
        
        UserDefaults.standard.string(forKey: "nickname")
        UserDefaults.standard.integer(forKey: "age")
        
        setUI()
        
        // 한국어 오름차순으로 pickerView에 표현
        sortedLangDict = languageList.sorted { $0.0 < $1.0 }
        
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
        
        guard let sourceValue = languageList[source] else { return }
        guard let targetValue = languageList[target] else { return }
        
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
        
        guard let text = originalTextView.text else { return }
        guard let oglang = originalLangTextField.text else { return }
        guard let trlang = transitionLangTextField.text else { return }
        guard let source = languageList[oglang] else { return }
        guard let target = languageList[trlang] else { return }
        
        PapagoAPIManager.shared.callRequest(text: text, source: source, target: target) { result in
            self.transitionTextView.text = result
        }
    }
    
}

extension PapagoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortedLangDict[row].key
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == originalPickerView {
            originalLangTextField.text = sortedLangDict[row].key
        } else {
            transitionLangTextField.text = sortedLangDict[row].key
        }
    }
    
}

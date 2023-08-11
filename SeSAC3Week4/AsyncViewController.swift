//
//  AsyncViewController.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {

    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstImageView.backgroundColor = .black
        print("1")
        
        DispatchQueue.main.async {
            self.firstImageView.layer.cornerRadius = self.firstImageView.frame.width / 2
            print("2")
        }
        print("3")
        
        for i in 1...100 {
            DispatchQueue.global().async {
                print(i, terminator: " ")
            }
        }

        for i in 101...200 {
            print(i, terminator: " ")
        }
        
    }
    
    // sync async serial concurent
    // UI Freezing
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        guard let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg") else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.firstImageView.image = UIImage(data: data)
            }
        }
    }
}

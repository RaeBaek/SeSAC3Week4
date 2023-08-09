//
//  VideoTableViewCell.swift
//  SeSAC3Week4
//
//  Created by 백래훈 on 2023/08/09.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    static let identifier = "VideoTableViewCell"
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 2
        thumbnailImageView.contentMode = .scaleToFill
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

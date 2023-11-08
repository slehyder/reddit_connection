//
//  SearchTableViewCell.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCountComments: UILabel!
    @IBOutlet weak var labelCountScore: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    var post: RedditPost? {
        didSet {
            
            guard let post = post else {
                return
            }
            
            labelTitle.text = post.title
            labelCountScore.text = post.score.kFormat
            labelCountComments.text = post.numComments.kFormat
            let processor = DownsamplingImageProcessor(size: imagePost.bounds.size)
            
            if let image = post.url {
                imagePost.kf.setImage(
                    with: URL(string: image),
                    placeholder: nil,
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage
                    ])
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        viewContainer.layer.shadowOpacity = 0.5
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        viewContainer.layer.shadowRadius = 5
        viewContainer.layer.masksToBounds = false
        imagePost.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imagePost.kf.cancelDownloadTask()
    }
}

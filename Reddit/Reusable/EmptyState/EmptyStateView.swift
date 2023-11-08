//
//  EmptyStateView.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import UIKit

class EmptyStateView: UIView {

    private let xibName = "EmptyStateView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelTitleContent: UILabel!
    
    var image : String?
    var title : String?
    var message: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(title: String, image: String, message: String) {
        super.init(frame: .zero)
        self.title = title
        self.image = image
        self.message = message
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        _ = NSLayoutConstraint.pinningEdges(view: contentView, toView: self)
        if let image = image {
            imageContent.image = UIImage(named: image)
        }

        if let title = title {
            labelTitleContent.text = title
        }
        
        if let message = message {
            labelContent.text = message
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        contentView.prepareForInterfaceBuilder()
    }
}

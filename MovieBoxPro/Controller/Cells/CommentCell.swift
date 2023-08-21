//
//  CommentCell.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/24/23.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let shorterSide = min(profileImage.layer.frame.width, profileImage.layer.frame.height)
        profileImage.layer.cornerRadius = shorterSide / 2
        profileImage.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//
//  MovieCell.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/4/23.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet var posterView: UIImageView!
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var starLabel: UILabel!
    
    @IBOutlet var Date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = cellView.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

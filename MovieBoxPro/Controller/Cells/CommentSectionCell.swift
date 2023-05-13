//
//  CommentSectionCell.swift
//  MovieBoxPro
//
//  Created by Noman Ashraf on 4/9/23.
//

import UIKit
class CommentSectionCell: UICollectionViewCell {
    @IBOutlet var content: UILabel!
    @IBOutlet var movie: UILabel!
    func configureWithData(_ comment: commentType) {
        content.text=comment.content
        movie.text = comment.movieName
    }
    
    
}

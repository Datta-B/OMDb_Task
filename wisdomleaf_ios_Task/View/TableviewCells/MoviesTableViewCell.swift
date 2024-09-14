//
//  MoviesTableViewCell.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 12/09/24.
//

import UIKit
import SDWebImage
import UIView_Shimmer

protocol MovieCellDelegate: AnyObject {
    func didToggleFavorite(index : Int)
}

class MoviesTableViewCell: UITableViewCell,ShimmeringViewProtocol {

    // IBOutlets
    @IBOutlet weak var imagePoster: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var releaseDateLbl: UILabel!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    weak var delegate : MovieCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteBtn.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc func favoriteButtonTapped() {
        delegate?.didToggleFavorite(index: favoriteBtn.tag)
    }
    
    
    func movieDetails(model : Search) {
        imagePoster.sd_setImage(with: URL(string: model.poster ?? ""),placeholderImage: UIImage(named: "movie_placeholder"))
        titleLbl.text = "Title : " + (model.title ?? "")
        releaseDateLbl.text = "ReleaseYear : " + (model.year ?? "")
        favoriteBtn.isSelected = model.isFavorite
        favoriteBtn.setImage(UIImage(systemName: model.isFavorite ? "heart.fill" : "heart"), for: .normal)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}


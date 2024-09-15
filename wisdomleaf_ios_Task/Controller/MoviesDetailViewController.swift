//
//  MoviesDetailViewController.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 12/09/24.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
        
    @IBOutlet weak var overViewLbl: UILabel!
    
    @IBOutlet weak var ratingLbl: UILabel!
    
    var search : Search = Search()
    
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        Configuration()
    }
    
    // MARK:- Configuration
    private func Configuration() {
        posterImage.sd_setImage(with: URL(string: search.poster ?? ""),placeholderImage: UIImage(named: "movie_placeholder"))
        posterImage.contentMode = .scaleAspectFill
        titleLbl.text = search.title
    }
    
}

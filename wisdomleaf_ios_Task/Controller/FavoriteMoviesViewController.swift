//
//  FavoriteMoviesViewController.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 14/09/24.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var FavoriteMoviesTableView: UITableView!
    var search = [Search]()
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        Configuration()
    }
    
    // Configuration
    private func Configuration() {
        
        // register cells
        let nib = UINib(nibName: "MoviesTableViewCell", bundle: nil)
        FavoriteMoviesTableView.register(nib, forCellReuseIdentifier: "MoviesTableViewCell")
        
        FavoriteMoviesTableView.delegate = self
        FavoriteMoviesTableView.dataSource = self
       // search.removeAll()
        search = FavoritesManager.shared.getFavorites()
        checkForEmptyData()
    }
    
    // Function to show placeholder if data is empty
      func checkForEmptyData() {
          if search.count <= 0 {
              setPlaceholder(message: "Empty...")
          } else {
              FavoriteMoviesTableView.backgroundView = nil
          }
          
          FavoriteMoviesTableView.reloadData()
      }
    
    // Function to set a custom placeholder view
       private func setPlaceholder(message: String) {
           let placeholderLabel = UILabel()
           placeholderLabel.text = message
           placeholderLabel.textAlignment = .center
           placeholderLabel.textColor = .gray
           placeholderLabel.font = UIFont.systemFont(ofSize: 18)
           placeholderLabel.sizeToFit()
           
           // Set the label as the background view of the table view
           FavoriteMoviesTableView.backgroundView = placeholderLabel
       }
    
}

extension FavoriteMoviesViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        search.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "MoviesTableViewCell"), for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        cell.movieDetails(model: search[indexPath.row])
        cell.favoriteBtn.isHidden = true
        cell.accessoryType = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
    
}

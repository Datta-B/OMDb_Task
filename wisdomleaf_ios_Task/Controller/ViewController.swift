//
//  ViewController.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 12/09/24.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
        
    lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var movieViewModel = MovieViewModel(httpclient: HttpClient())

    private var searchWorkItem: DispatchWorkItem?

    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Configuration()
        setUpBinding()
    }
    
    // Configuration
    private func Configuration() {
        
        title = "Movies"
        
        // register cells
        let nib = UINib(nibName: "MoviesTableViewCell", bundle: nil)
        moviesTableView.register(nib, forCellReuseIdentifier: "MoviesTableViewCell")
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
       // stackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(moviesTableView)
        
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setUpBinding() {
        movieViewModel.states.bind { result in
            switch result {
            case .loading:
                print("loading")
            case .populated:
                DispatchQueue.main.async { [weak self] in
                    self?.moviesTableView.reloadData()
                }
            case .erro(_):
                print("error")
            }
        }
    }
    
    private func search(withText text: String) {
          searchWorkItem?.cancel()
          
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            movieViewModel.getMoviesList(searchTxt: text)
        }
          
          searchWorkItem = task
          
          // Excute the workitem after 0.3 seconds.
          DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: task)
      }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.response.search?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "MoviesTableViewCell"), for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        let movieListResult = movieViewModel.response.search
        
        cell.movieDetails(model: movieListResult?[indexPath.row] ?? Search())
        
        cell.favoriteBtn.tag = indexPath.row
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}

extension ViewController : MovieCellDelegate {
    func didToggleFavorite(index: Int) {
        movieViewModel.response.search?[index].isFavorite.toggle()
        moviesTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            search(withText: searchText)
        }
}

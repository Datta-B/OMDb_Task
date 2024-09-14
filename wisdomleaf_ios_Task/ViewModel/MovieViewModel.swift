//
//  MovieViewModel.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 12/09/24.
//

import Foundation
import Combine

enum states {
    case loading
    case idle
    case noResults
    case success
    case failure(Error)
}

class MovieViewModel  {
    var response : MovieResponse = MovieResponse()
    var states : Observable<states> = .init(.idle)
    var httpclient : HttpClient
    
    init( httpclient: HttpClient) {
        self.httpclient = httpclient
    }
    
    func getMoviesList(searchTxt : String) {
        self.states.value = .loading
        httpclient.fetchRequest("http://www.omdbapi.com/?apikey=a94b7bb0&type=movie&s=\(searchTxt)", type: MovieResponse.self) { result in
            switch result {
            case .success(let data):
                if data.totalResults != nil{
                    self.states.value = .success
                    self.response = data
                }else{
                    self.states.value = .noResults
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
    }
}

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
    case populated
    case erro(message : String)
}

class MovieViewModel  {
    var response : MovieResponse = MovieResponse()
    var states : Observable<states> = .init(.loading)
    var httpclient : HttpClient
    
    init( httpclient: HttpClient) {
        self.httpclient = httpclient
    }
    
    func getMoviesList(searchTxt : String) {
        httpclient.fetchRequest("http://www.omdbapi.com/?apikey=a94b7bb0&type=movie&s=\(searchTxt)", type: MovieResponse.self) { result in
            switch result {
            case .success(let data):
                self.states.value = .populated
                self.response = data
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
    }
}

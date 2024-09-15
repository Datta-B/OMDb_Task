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
    var httpclient: NetworkRequestProtocol
    
    init(httpclient: NetworkRequestProtocol) {
        self.httpclient = httpclient
    }
    
    func getMoviesList(searchTxt : String) {
        self.states.value = .loading
        httpclient.fetchRequest("\(Constants.baseURL)/?apikey=\(Constants.ApiKey)&type=movie&s=\(searchTxt)", type: MovieResponse.self) { result in
            switch result {
            case .success(let data):
                if data.totalResults != nil{
                    self.response = data
                    self.states.value = .success
                }else{
                    self.states.value = .noResults
                    self.response.search = []
                }
            case .failure(let failure):
                self.states.value = .failure(failure)
            }
        }
    }
}

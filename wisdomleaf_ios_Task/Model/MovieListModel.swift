//
//  MovieListModel.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 12/09/24.
//

import Foundation

struct MovieResponse: Codable {
    var search: [Search]?
    let totalResults, response: String?

    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
    
    init(search: [Search]? = nil, totalResults: String? = nil, response: String? = nil) {
           self.search = search
           self.totalResults = totalResults
           self.response = response
       }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID: String?
    let type: TypeEnum?
    let poster: String?
    var isFavorite : Bool = false

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
    // Custom initializer with default values
    init(title: String? = nil, year: String? = nil, imdbID: String? = nil, type: TypeEnum? = nil, poster: String? = nil) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.type = type
        self.poster = poster
    }
}
enum TypeEnum: String, Codable {
    case movie = "movie"
}

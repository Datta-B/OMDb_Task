//
//  UserDefaultsFile.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 14/09/24.
//

import Foundation
class FavoritesManager {
    
    static let shared = FavoritesManager()
    
    private let favoritesKey = "favoriteSearches"
    
    // Save updated Search object when selected as favorite
    func saveFavorite(search: Search) {
        var currentFavorites = getFavorites()
        
        if let index = currentFavorites.firstIndex(where: { $0.imdbID == search.imdbID }) {
            // Update existing favorite
            currentFavorites[index] = search
        } else {
            // Add new favorite
            currentFavorites.append(search)
        }
        
        UserDefaults.standard.setObject(currentFavorites, forKey: favoritesKey)
    }
    
    // Remove Search object from favorites
    func removeFavorite(search: Search) {
        var currentFavorites = getFavorites()
        
        if let index = currentFavorites.firstIndex(where: { $0.imdbID == search.imdbID }) {
            currentFavorites.remove(at: index)
        }
        
        UserDefaults.standard.setObject(currentFavorites, forKey: favoritesKey)
    }
    
    // Retrieve all favorite Search objects
    func getFavorites() -> [Search] {
        return UserDefaults.standard.object([Search].self, withKey: favoritesKey) ?? []
    }
    
    // Check if a Search object is already marked as favorite
    func isFavorite(search: Search) -> Bool {
        return getFavorites().contains(where: { $0.imdbID == search.imdbID })
    }
}

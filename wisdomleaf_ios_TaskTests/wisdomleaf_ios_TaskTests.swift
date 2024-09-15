//
//  wisdomleaf_ios_TaskTests.swift
//  wisdomleaf_ios_TaskTests
//
//  Created by dattaz biradar on 12/09/24.
//

import XCTest
@testable import wisdomleaf_ios_Task

class MockHttpClient: NetworkRequestProtocol {
    
    var shouldReturnError = false
    var mockResponseData: Data?
    var mockError: Error?
    
    func fetchRequest<T: Codable>(_ url: String, type: T.Type, handler: @escaping (Result<T, Error>) -> ()) {
        // Simulate error case
        if shouldReturnError {
            if let error = mockError {
                handler(.failure(error))
            } else {
                handler(.failure(NetworkError.badResponse(500)))  // Default error
            }
            return
        }
        
        // Simulate success case
        if let data = mockResponseData {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                handler(.success(decodedData))
            } catch {
                handler(.failure(NetworkError.decodingError))
            }
        } else {
            handler(.failure(NetworkError.noData))
        }
    }
}

final class wisdomleaf_ios_TaskTests: XCTestCase {
    
     var viewModel: MovieViewModel!
       var mockHttpClient: MockHttpClient!
       
       override func setUp() {
           super.setUp()
           // Arrange: Initialize MockHttpClient and MovieViewModel
           mockHttpClient = MockHttpClient()
           viewModel = MovieViewModel(httpclient: mockHttpClient)
       }
       
       override func tearDown() {
           // Teardown: Clean up resources, if necessary
           mockHttpClient = nil
           viewModel = nil
           super.tearDown()
       }
       
    func testJSONDecoding() {
            let jsonResponse = """
            {
                "Search": [
                    {
                        "Title": "Testing Movie1",
                        "Year": "2015",
                        "imdbID": "tt2418644",
                        "Type": "movie",
                        "Poster": "poster_url",
                        "isFavorite": false
                    }
                ],
                "totalResults": "1",
                "Response": "True"
            }
            """.data(using: .utf8)
            
            do {
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: jsonResponse!)
                print("Decoded Response: \(decodedResponse)")
            } catch {
                print("Decoding error: \(error)")
            }
        }
    
       func testGetMoviesList_Success() {
           // Arrange
           let jsonResponse = """
           {
               "Search": [
                   {
                       "Title": "Testing Movie1",
                       "Year": "2015",
                       "imdbID": "tt2418644",
                       "Type": "movie",
                       "Poster": "poster_url",
                       "isFavorite": false
                   }
               ],
               "totalResults": "1",
               "Response": "True"
           }
           """.data(using: .utf8)
           
           mockHttpClient.mockResponseData = jsonResponse
           mockHttpClient.shouldReturnError = false
           
           let expectation = self.expectation(description: "Success response")
           
           // Act
           viewModel.states.bind { state in
               if case .success = state {
                   // Assert
                   XCTAssertEqual(self.viewModel.response.search?.count, 1)
                   XCTAssertEqual(self.viewModel.response.search?.first?.title, "Testing Movie1")
                   expectation.fulfill()
               }
           }
           
           viewModel.getMoviesList(searchTxt: "Movie1")
           
           waitForExpectations(timeout: 1.0, handler: nil)
       }

       
       func testGetMoviesList_Failure() {
           // Arrange
           mockHttpClient.shouldReturnError = true
           mockHttpClient.mockError = NSError(domain: "MockError", code: 500, userInfo: nil)
           
           let expectation = self.expectation(description: "Failure response")
           
           // Act
           viewModel.states.bind { state in
               if case .failure = state {
                   // Assert
                   expectation.fulfill()
               }
           }
           
           viewModel.getMoviesList(searchTxt: "Movie1")
           
           waitForExpectations(timeout: 1.0, handler: nil)
       }
}



//
//  FlickrSearchService.swift
//  flickrApp
//
//  Created by Balraj Singh on 08/12/18.
//  Copyright © 2018 balraj. All rights reserved.
//

import Foundation

struct FlickrSearchService {
     var searchTask: URLSessionDataTask?
    
    let restService = RESTService(baseUrl: "https://api.flickr.com/services/rest")
    
    mutating func search(forWord word: String, pageNo: Int,_ completionHandler: @escaping (Result<FlickrSearchResponse, ServiceError<Error>>) -> ()) {
        // cancel the previous task
        searchTask?.cancel()
        
        // create request resource
        let searchRequestResource = Resource<FlickrSearchResponse, CustomError>(jsonDecoder: JSONDecoder(), path: self.searchRequestUrlMaker(forWord: word, pageNo: pageNo))
        
        // make request
        searchTask = self.restService.load(resource: searchRequestResource) { response in
            switch response {
            case .success(let searchResponse):
                completionHandler(Result.success(searchResponse))
            case .failure(_):
               completionHandler(Result.failure(ServiceError.other))
            }
        }
    }
    
    private func searchRequestUrlMaker(forWord word: String, pageNo: Int) -> String {
        return "/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&%20format=json&nojsoncallback=1&safe_search=1&text=\(word)&page=\(pageNo)"
    }
}

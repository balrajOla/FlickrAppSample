//
//  FlickrSearchUsecase.swift
//  flickrApp
//
//  Created by Balraj Singh on 09/12/18.
//  Copyright © 2018 balraj. All rights reserved.
//

import Foundation

class FlickrSearchUsecase {
    private var searchWord: String?
    
    private var flickrService: FlickrSearchService = FlickrSearchService()
    
    private var paginator: Paginator<FlickrSearchResponse>?
    
    func setUp() {
        paginator = Paginator(pageSize: 100, asyncTask: { (pageNo, pageSize, completionHandler) in
            guard let searchKeyword = self.searchWord else {
                completionHandler(Result.failure(ServiceError.noDataToSearchFor))
             return
            }
            
            self.flickrService.search(forWord: searchKeyword, pageNo: pageNo, completionHandler)
        })
    }
    
    func search(forWord word: String, _ completionHandler: @escaping (Result<FlickrSearchResponse, ServiceError<Error>>) -> Void) {
        if let prevSearchWord = self.searchWord,
            prevSearchWord == word {
            // update the search word
            self.paginator?.fetchNextPage(completionHandler)
        } else {
            self.searchWord = word
            self.paginator?.fetchFirstPage(completionHandler)
        }
    }
}

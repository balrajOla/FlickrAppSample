//
//  FlickrSearchResponse.swift
//  flickrApp
//
//  Created by Balraj Singh on 09/12/18.
//  Copyright © 2018 balraj. All rights reserved.
//

import Foundation

public class FlickrSearchResponse: Codable {
    // MARK: Properties
    public var stat: String?
    public var photos: Photos?
}

public class Photos: Codable {
    // MARK: Properties
    public var total: String?
    public var page: Int?
    public var perpage: Int?
    public var pages: Int?
    public var photo: [Photo]?
}

public class Photo: Codable {
    
    // MARK: Properties
    public var isfriend: Int?
    public var farm: Int?
    public var id: String?
    public var server: String?
    public var secret: String?
    public var owner: String?
    public var title: String?
    public var ispublic: Int?
    public var isfamily: Int?
}

// MARK: Pagination Logic
extension FlickrSearchResponse: Aggregatable {
    public func aggregate(result: Aggregatable) -> Aggregatable {
        guard let inputData = result as? FlickrSearchResponse else {
            return result
        }
        
        self.photos?.page = inputData.photos?.pages
        inputData.photos?.photo.map { photoRes in self.photos?.photo?.append(contentsOf: photoRes) }
        
        return self
    }
}

extension FlickrSearchResponse: Pagination {
    public func isNextPageAvailable() -> Bool {
        guard let pageNo = self.photos?.page,
            let totalPageNos = self.photos?.pages else {
                return false
        }
        
        return pageNo < totalPageNos
    }
    
    public func updatePaginationStatus(next: Bool) {
        // Do nothing as Page status is calculated on the fly
    }
}

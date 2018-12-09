//
//  ServiceError.swift
//  flickrApp
//
//  Created by Balraj Singh on 09/12/18.
//  Copyright © 2018 balraj. All rights reserved.
//

import Foundation

public enum ServiceError<CustomError>: Error {
    case noDataToSearchFor
    case noInternetConnection
    case custom(CustomError)
    case unauthorized
    case other
    
    case executionInProgress
    case dataNotAvailable
    case pagesCompleted
}

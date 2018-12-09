//
//  StringExtension.swift
//  flickrApp
//
//  Created by Balraj Singh on 09/12/18.
//  Copyright © 2018 balraj. All rights reserved.
//

import Foundation

public extension String {
    public static func stringFromClass(_ anyClass : AnyClass) -> String {
        let string = NSStringFromClass(anyClass)
        return string.components(separatedBy: ".").last!
    }
}

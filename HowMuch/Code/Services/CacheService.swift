//
//  CacheService.swift
//  HowMuch
//
//  Created by Svetlana T on 22.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

class CacheService {
    static let shared = CacheService()
    private var cachedData: NSCache<NSString, AnyObject>

    private init() {
        cachedData = NSCache<NSString, AnyObject>()
    }

    func saveObject(_ object: AnyObject, forKey key: NSString) {
        cachedData.setObject(object, forKey: key)
    }

    func object(forKey key: NSString) -> AnyObject? {
        return cachedData.object(forKey: key)
    }
}

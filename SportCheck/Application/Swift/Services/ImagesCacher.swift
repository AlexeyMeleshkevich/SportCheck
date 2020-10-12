//
//  ImagesCacher.swift
//  SportCheck
//
//  Created by Alexey Meleshkevich on 07.10.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import Foundation
import UIKit

class ImagesCacher {
    var cache = NSCache<NSString, UIImage>()
    
    static let shared = ImagesCacher()
    private init() {}
    
    func checkCache(for key: String) -> UIImage? {
        guard let image = cache.object(forKey: key as NSString) else { return nil }
        return image
    }
}

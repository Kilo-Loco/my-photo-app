//
//  ImageCache.swift
//  My-Photo-App
//
//  Created by Kyle Lee on 7/11/20.
//

import UIKit

class ImageCache: NSCache<NSString, UIImage> {
    static let shared = ImageCache()
    private override init() {}
    
    func add(_ image: UIImage, for key: String) {
        setObject(image, forKey: key as NSString)
    }
    
    func image(for key: String) -> UIImage? {
        object(forKey: key as NSString)
    }
}

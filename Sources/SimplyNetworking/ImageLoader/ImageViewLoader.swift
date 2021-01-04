//
//  File.swift
//  
//
//  Created by Lee Burrows on 04/12/2019.
//

#if !os(macOS)

import UIKit

/// Singleton Class to manage GETing UIImages and loading into UIImageView instances.
public final class UIImageLoader {
    public static let loader = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    public func load(_ url: URL, for imageView: UIImageView) {
        let token = imageLoader.loadImage(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
                // handle error
            }
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    public func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}

#else
#endif

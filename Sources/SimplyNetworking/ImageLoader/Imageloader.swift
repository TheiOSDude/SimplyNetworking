//
//  ImageLoader.swift
//  
//
//  Created by Lee Burrows on 04/12/2019.
//


#if !os(macOS)
import UIKit

/// ImageLoader provides getting, caching (In Memory), and cancelable image download tasks.
public final class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    public func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()
        runningRequests[uuid] = task
        return uuid
        
    }
    
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
}

#else
#endif


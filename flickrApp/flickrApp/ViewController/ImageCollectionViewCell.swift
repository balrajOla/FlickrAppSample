//
//  ImageCollectionViewCell.swift
//  flickrApp
//
//  Created by Balraj Singh on 09/12/18.
//  Copyright © 2018 balraj. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView?
    
    private var imageUrlString: String?
    
    private var downloadTask: URLSessionDownloadTask?
    public var imageURL: URL? {
        didSet {
            self.downloadItemImageForSearchResult(imageURL: imageURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    public func setUpData(forPhoto photo: Photo) {
        // verify if all data is avialable
        // prepare url from the above data
        guard let farm = photo.farm,
            let server = photo.server,
            let id = photo.id,
            let secret = photo.secret,
            let imageUrl = URL.init(string: "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg") else {
                self.downloadTask?.cancel()
                imgView?.image = #imageLiteral(resourceName: "Placeholder")
                return
        }
        
        // start downloading image
        self.downloadItemImageForSearchResult(imageURL: imageUrl)
    }
    
    private func downloadItemImageForSearchResult(imageURL: URL?) {
        
        if let urlOfImage = imageURL {
            if let cachedImage = imageCache.object(forKey: urlOfImage.absoluteString as NSString) {
                self.imgView?.image = cachedImage as? UIImage
            } else {
                let session = URLSession.shared
                self.downloadTask = session.downloadTask(
                    with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
                        if error == nil, let url = url, let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
                            
                            DispatchQueue.main.async() {
                                
                                let imageToCache = image
                                
                                if let strongSelf = self, let imageView = strongSelf.imgView {
                                    
                                    imageView.image = imageToCache
                                    
                                    imageCache.setObject(imageToCache, forKey: urlOfImage.absoluteString as NSString , cost: 1)
                                }
                            }
                        }
                })
                self.downloadTask!.resume()
            }
        }
    }
    
    override public func prepareForReuse() {
        self.downloadTask?.cancel()
        imgView?.image = #imageLiteral(resourceName: "Placeholder")
    }
    
    deinit {
        self.downloadTask?.cancel()
        imgView?.image = nil
    }
}

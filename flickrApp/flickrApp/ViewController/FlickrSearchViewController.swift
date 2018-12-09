//
//  FlickrSearchViewController.swift
//  flickrApp
//
//  Created by Balraj Singh on 08/12/18.
//  Copyright © 2018 balraj. All rights reserved.
//

import UIKit

class FlickrSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var searchUsecase = FlickrSearchUsecase()
    
    var dataSource: FlickrSearchResponse?
    
    var isLoading: Bool = false
    
    init() {
        super.init(nibName: String.stringFromClass(FlickrSearchViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchUsecase.setUp()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: CollectionView Delegate & DataSource
extension FlickrSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.photos?.photo?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath as IndexPath) as! ImageCollectionViewCell
        
        // get data based on index
        if let photoData = self.dataSource,
            let photo = photoData.photos?.photo?[indexPath.row] {
            myCell.setUpData(forPhoto: photo)
        }
        
        return myCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY >= (scrollView.contentSize.height - scrollView.bounds.height) - 50 {
            guard !self.isLoading else { return }
            self.isLoading = true
            
            guard let text = self.searchBar.text else {
                self.isLoading = false
                return
            }
            
            self.searchUsecase.search(forWord: text) { (result: Result<FlickrSearchResponse, ServiceError<Error>>) in
                // set the data if success
                _ = result.map({ (response) -> Void in
                    self.isLoading = false
                    self.dataSource = response
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
}

// MARK: Search Delegate
extension FlickrSearchViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchUsecase.search(forWord: searchText) { (result: Result<FlickrSearchResponse, ServiceError<Error>>) in
            // set the data if success
            _ = result.map({ (response) -> Void in
                self.dataSource = response
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        }
    }
}

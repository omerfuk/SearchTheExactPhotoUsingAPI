//
//  ViewController.swift
//  SearchTheExactPhotoUsingAPI
//
//  Created by Ömer Faruk Kılıçaslan on 14.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var results: [Result] = []
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=office&client_id=8v55atTFhjnu3fr-PT0cEYO8i86q5gf4mq_9W0yiF80"
    
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width / 2, height: view.frame.size.width / 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        fetchPhotos()
        
    }
    
    func fetchPhotos() {
        
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data = data, error == nil else {return}
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                    
                }
                
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    

}


extension ViewController: UICollectionViewDataSource, UINavigationControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
}

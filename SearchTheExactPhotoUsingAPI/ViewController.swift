//
//  ViewController.swift
//  SearchTheExactPhotoUsingAPI
//
//  Created by Ömer Faruk Kılıçaslan on 14.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var results: [Result] = []
    
    let searchBar = UISearchBar()
    
    
    
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        searchBar.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width / 2, height: view.frame.size.width / 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        fetchPhotos(with: "")
        
    }
    
    func fetchPhotos(with query: String) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id=8v55atTFhjnu3fr-PT0cEYO8i86q5gf4mq_9W0yiF80"
        
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
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width - 20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.frame.size.width, height: view.frame.size.height - 55)
        
    }
    

}


extension ViewController: UICollectionViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(with: imageURLString)
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            results = []
            fetchPhotos(with: text)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }

//            if results.count == 0 {
//                makeAlert(title: "Error", message: "Unable to find '\(text)' word, please try again")
//
//            }
        }
    }
    
    func makeAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}



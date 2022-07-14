//
//  ViewController.swift
//  SearchTheExactPhotoUsingAPI
//
//  Created by Ömer Faruk Kılıçaslan on 14.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=office&client_id=8v55atTFhjnu3fr-PT0cEYO8i86q5gf4mq_9W0yiF80"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
    }
    
    func fetchPhotos() {
        
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {return}
            
            print("Got Data")
        }
        task.resume()
        
    }


}


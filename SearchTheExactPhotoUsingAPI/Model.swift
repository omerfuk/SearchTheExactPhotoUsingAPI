//
//  Model.swift
//  SearchTheExactPhotoUsingAPI
//
//  Created by Ömer Faruk Kılıçaslan on 14.07.2022.
//

import Foundation

struct APIResponse: Codable {
    
    let total: Int
    let total_pages: Int
    let results: [Result]
    
}

struct Result: Codable {
    
    let id: String
    let urls: URLS
    
    
}


struct URLS:Codable {
    
    let regular:String
    
}



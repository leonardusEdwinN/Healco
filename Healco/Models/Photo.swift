//
//  Photo.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 16/06/21.
//

import Foundation
import UIKit

//struct Photo{
//    var image: UIImage
//    var title: String
//    var description: String
//}

class Photo {
    var image: UIImage
    var title: String = ""
    var description: String = ""
    var status: String = ""
    
    init(image: UIImage, title : String, description : String, status: String) {
        self.image = image
        self.title = title
        self.description = description
        self.status = status
    }
    
    static func fetchDummyData() -> [Photo] {
        return[
            Photo(image: UIImage(named: "p1")!, title: "First Journal", description: "First Journal Description", status : ""),
            Photo(image: UIImage(named: "p2")!, title: "Second Journal", description: "Second Journal Description", status : ""),
            Photo(image: UIImage(named: "p3")!, title: "Third Journal", description: "Third Journal Description", status : ""),
            Photo(image: UIImage(named: "p4")!, title: "Fourth Journal", description: "Fourth Journal Description", status : ""),
        ]
    }
}


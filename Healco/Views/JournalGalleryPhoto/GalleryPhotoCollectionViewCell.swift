//
//  GalleryPhotoCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 16/06/21.
//

import UIKit

class GalleryPhotoCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var photoGalleryView: UIImageView!
    @IBOutlet weak var labelTitleGalleryPhoto: UILabel!
    @IBOutlet weak var labelDescriptionGalleryPhoto: UILabel!
    
//    var photo: Photo! {
//        didSet{
//            self.updateUI()
//        }
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(dataPhoto : Photo){
        self.labelTitleGalleryPhoto.text = dataPhoto.title
        self.labelDescriptionGalleryPhoto.text = dataPhoto.description
        self.photoGalleryView.image = dataPhoto.image
        
        self.photoGalleryView.layer.cornerRadius = 15
        self.photoGalleryView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
    }
    
    
//    func updateUI(){
//        if let photo = photo{
//            photoGalleryView.image = photo.image
////            labelTitleGalleryPhoto.text = photo.title
////            labelDescriptionGalleryPhoto.text = photo.description
//        }else{
//            photoGalleryView.image = nil
////            labelTitleGalleryPhoto.text = "Title Gallery Photo"
////            labelDescriptionGalleryPhoto.text = "Description gallery photo"
//        }
//
//    }

}

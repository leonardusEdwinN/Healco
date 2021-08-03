//
//  OnboardingViewController.swift
//  Healco
//
//  Created by Fahmi Dzulqarnain on 18/06/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    
    var indexPaths: IndexPath!
    
    var slides = [OnboardingSlide]()
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                btnNext.setTitle("Understandable, Lets Go!", for: .normal)
            } else {
                btnNext.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slides = [
            OnboardingSlide(title: "Ketahui Makananmu", description: "Cekrek, cekrek, ambil foto dan dapatkan informasi nutrisi yang ada di makanan kamu.", image: UIImage(named: "onboarding-image-1")!),
            OnboardingSlide(title: "Yuk Bikin Diary!", description: "Nge-diary apa yang kamu makan terbukti menurunkan berat badan lho, tentunya dengan memperbaiki setelah tahu yang salah ya.", image: UIImage(named: "onboarding-image-2")!),
            OnboardingSlide(title: "Perbaiki Pola Makan", description: "Nah, nge-diary apa yang kamu makan bakalan ngebantu untuk memperbaiki pola makan supaya sehat lho.", image: UIImage(named: "onboarding-image-3")!)
        ]
        
        pageControl.numberOfPages = slides.count
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    @IBAction func btn_next_click(_ sender: Any) {
        if currentPage == slides.count - 1 {
//            let storyboard = UIStoryboard(name: "JournalViewController", bundle: nil);
//
//            let viewController = storyboard.instantiateViewController(withIdentifier: "JournalViewController") as! JournalViewController;
            
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil);
            let viewController = storyboard.instantiateViewController(withIdentifier: "OnboardingLogin")
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        } else {
            currentPage += 1
            collectionView.isPagingEnabled = false
            collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
        }
    }
    
    
}

extension OnboardingViewController: UICollectionViewDelegate {
    
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        indexPaths = indexPath
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
}

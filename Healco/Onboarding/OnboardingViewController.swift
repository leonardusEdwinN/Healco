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
            OnboardingSlide(title: "Knowing Healthy Meal", description: "Capture your meal and get to know if its nutrition good or not", image: UIImage(named: "onboarding-image-1")!),
            OnboardingSlide(title: "Do Food Diary", description: "By doing food diary, you’ll help yourself to track what’s wrong in your food consumption.", image: UIImage(named: "onboarding-image-2")!),
            OnboardingSlide(title: "Improve habit", description: "We will give you summary from your diary to improve your habit", image: UIImage(named: "onboarding-image-3")!)
        ]
        
        pageControl.numberOfPages = slides.count
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    @IBAction func btn_next_click(_ sender: Any) {
        if currentPage == slides.count - 1 {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil);
//
//            let viewController = storyboard.instantiateViewController(withIdentifier: "HomeView") as! MainPageViewController;
//            viewController.modalTransitionStyle = .crossDissolve
//            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true, completion: nil)
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

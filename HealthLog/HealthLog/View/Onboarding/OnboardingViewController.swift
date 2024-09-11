//  OnboardingViewController.swift
//  HealthLog
//
//  Created by seokyung on 9/11/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let skipButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(image: UIImage(named: "Main")),
        OnboardingPage(image: UIImage(named: "AddExercise")),
        OnboardingPage(image: UIImage(named: "Routine")),
        OnboardingPage(image: UIImage(named: "Report"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .color1E1E1E
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        
        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.addTarget(self, action: #selector(skipOnboarding), for: .touchUpInside)
        skipButton.tintColor = .gray
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        nextButton.tintColor = .white
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            
            skipButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        setupPages()
    }
    
    private func setupPages() {
        for (index, page) in pages.enumerated() {
            let pageView = OnboardingPageView(page: page)
            scrollView.addSubview(pageView)
            pageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                pageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.bounds.width),
                pageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                pageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
        scrollView.contentSize = CGSize(width: CGFloat(pages.count) * view.bounds.width, height: scrollView.bounds.height)
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "HasCompletedOnboarding")
        UserDefaults.standard.synchronize()
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = sceneDelegate.createTabBarController()
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    @objc private func skipOnboarding() {
        completeOnboarding()
    }
    
    @objc private func nextPage() {
        if pageControl.currentPage == pages.count - 1 {
            completeOnboarding()
        } else {
            let nextPage = pageControl.currentPage + 1
            let point = CGPoint(x: scrollView.frame.width * CGFloat(nextPage), y: 0)
            scrollView.setContentOffset(point, animated: true)
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

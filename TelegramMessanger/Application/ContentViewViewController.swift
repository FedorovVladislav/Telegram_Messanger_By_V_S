//
//  ContentViewViewController.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 14.03.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit

class ContentViewViewController: UIViewController {
    
    let scrolView: UIScrollView = {
        let scrolView = UIScrollView()
        scrolView.maximumZoomScale = 3
        scrolView.minimumZoomScale = 1
        scrolView.translatesAutoresizingMaskIntoConstraints = false
        scrolView.backgroundColor = .black
        
        return scrolView
    }()
    let imageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFill
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
      

        return uiImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrolView.delegate = self

        view.addSubview(scrolView)
        view.addSubview(imageView)
        
        setConstraints()
    }
    
    private func  setConstraints() {
        NSLayoutConstraint.activate([
            scrolView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrolView.topAnchor.constraint(equalTo: view.topAnchor),
            scrolView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrolView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.leftAnchor.constraint(equalTo: scrolView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: scrolView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrolView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrolView.bottomAnchor)
        ])
    }

}
extension ContentViewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

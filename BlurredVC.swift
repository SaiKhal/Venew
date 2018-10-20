//
//  BlurredVC.swift
//  Venew
//
//  Created by Masai Young on 10/19/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

class BlurredVC: UIViewController {
    lazy var blurredBackgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
//        view.backgroundColor = .lightGray
//        view.alpha = 0.3
        addBlurredEffectView()
        addModal()
        addTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBlurredEffectView() {
        view.insertSubview(blurredBackgroundView, at: 0)
        blurredBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        NSLayoutConstraint.activate([
//            blurredBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            blurredBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
//        ])
    }
    
    func addModal() {
        let modal = UIView(frame: CGRect(x: 100, y: 100, width: 150, height: 150))
        modal.backgroundColor = .blue
        view.addSubview(modal)
        modal.center = view.center
//        modal.translatesAutoresizingMaskIntoConstraints = false
//        modal.snp.makeConstraints { make in
//            make.width.equalTo(blurredBackgroundView.snp.width).multipliedBy(3/4)
//            make.height.equalTo(modal.snp.width)
//        }
    }
    
    func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(_:)))
        blurredBackgroundView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapBackground(_ sender: UITapGestureRecognizer) {
        print("tapped")
        dismiss(animated: false, completion: nil)
    }
}

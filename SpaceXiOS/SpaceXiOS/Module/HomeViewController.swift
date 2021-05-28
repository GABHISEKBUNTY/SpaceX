//
//  ViewController.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 28/05/21.
//

import UIKit

class HomeViewController: UIViewController {
    private lazy var mainContainerStackView: UIStackView = UIStackView.buildView {
        $0.axis = .horizontal
    }
    
    private lazy var titleLabel: UILabel = UILabel.buildView {
        $0.font = .systemFont(ofSize: 17)
    }
    
    private lazy var imageView: UIImageView = UIImageView.buildView()
    
    private lazy var explanationLabel: UILabel = UILabel.buildView {
        $0.font = .systemFont(ofSize: 14)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        view.backgroundColor = .systemBackground
        title = "Pic of the Day"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(mainContainerStackView)
        
        [titleLabel, imageView, explanationLabel].forEach { mainContainerStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            mainContainerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainContainerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainContainerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            mainContainerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8)
        ])
    }
}

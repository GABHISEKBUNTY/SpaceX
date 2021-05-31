//
//  ViewController.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 28/05/21.
//

import UIKit

final class HomeViewController: UIViewController {
    private lazy var mainContainerStackView: UIStackView = UIStackView.buildView {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private lazy var titleLabel: UILabel = UILabel.buildView {
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    private lazy var spaceImageView: UIImageView = UIImageView.buildView {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var explanationLabel: UILabel = UILabel.buildView {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let viewModel: HomeViewRepresentable
    
    init(viewModel: HomeViewRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewLoaded()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(mainContainerStackView)
        
        [titleLabel, spaceImageView, explanationLabel, UIView()].forEach { mainContainerStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            mainContainerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainContainerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainContainerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mainContainerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            spaceImageView.heightAnchor.constraint(equalTo: spaceImageView.widthAnchor)
        ])
    }
    
    private func setupBinding() {
        viewModel.refreshUI = { [weak self] presentationData in
            DispatchQueue.main.async {
                self?.renderDataOnUI(presentationData)
            }
        }
        
        viewModel.showError = { [weak self] errorContent in
            DispatchQueue.main.async {
                self?.showErrorMessage(errorContent)
            }
        }
    }
    
    private func renderDataOnUI(_ presentationData: APODDataModel) {
        titleLabel.text = presentationData.title
        explanationLabel.text = presentationData.explanation
        
        if let imageURL = URL(string: presentationData.url) {
            spaceImageView.load(url: imageURL)
        }
    }
    
    private func showErrorMessage(_ errorContent: ErrorContent) {
        let alert = UIAlertController(title: nil, message: errorContent.errorMessage, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

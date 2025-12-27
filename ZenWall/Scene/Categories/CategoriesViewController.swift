//
//  CategoriesViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import UIKit

final class CategoriesViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CompositionalLayoutFactory.makeGridLayout())
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        return cv
    }()
    
    // MARK: - Init
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let viewModel: CategoriesViewModel
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UI Setup
    override func layoutUI() {
        title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Bindings
    override func bindViewModel() {
        viewModel.success = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.failure = { errorMsg in
            print("ERROR: \(errorMsg)")
        }
        viewModel.fetchNewCategories()
    }
}

// MARK: - CollectionView Delegate & DataSource
extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let model = viewModel.categories[indexPath.item]
        
        cell.configure(title: model.title ?? "",cover: model.coverPhoto?.urls?.regular ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slug = viewModel.categories[indexPath.item].slug ?? ""
        let topicName = viewModel.categories[indexPath.item].title ?? ""
        let coordinator = CategoriesCoordinator(navigationController: navigationController ?? UINavigationController())
        coordinator.showList(for: slug, topicName: topicName)
    }
}

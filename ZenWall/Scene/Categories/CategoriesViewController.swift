//
//  CategoriesViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel: CategoriesViewModel
    private let coordinator: CategoriesCoordinator
    
    // MARK: - Init
    init(viewModel: CategoriesViewModel, coordinator: CategoriesCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavigationBar()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchNewCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyColoredNavBar()
        enableLargeTitle()
        title = "Categories"
    }
    
    private func bindViewModel() {
        viewModel.success = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.failure = { errorMsg in
            print("ERROR: \(errorMsg)")
        }
    }
    
    // MARK: - CollectionView + Gradient
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1).cgColor,
            UIColor(red: 0.09, green: 0.12, blue: 0.10, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
        
        let gradientView = UIView(frame: UIScreen.main.bounds)
        gradientView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = gradientView
    }
    
    // MARK: - Navigation Bar Style
    private func setupNavigationBar() {
        title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1)
        appearance.shadowColor = .clear
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
}

extension CategoriesViewController {
    static func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(260)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(260)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            return section
        }
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
        coordinator.showList(for: slug)
    }
}

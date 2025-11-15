//
//  ListViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 14.11.25.
//

import UIKit

class ListViewController: UIViewController {
    
    private let viewModel: ListViewModel
    private let coordinator: CategoriesCoordinator
    
    init(viewModel: ListViewModel, coordinator: CategoriesCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = ListViewController.createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(HeaderCell.self, forCellWithReuseIdentifier: "HeaderCell")
        cv.register(WallpaperOfDayCell.self, forCellWithReuseIdentifier: "WallpaperOfDayCell")
        cv.register(WallpaperCell.self, forCellWithReuseIdentifier: "WallpaperCell")
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyColoredNavBar()
        disableLargeTitle()
        setupGradientBackground()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1).cgColor,
            UIColor(red: 0.09, green: 0.12, blue: 0.10, alpha: 1).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        
        let bgView = UIView(frame: view.bounds)
        bgView.layer.addSublayer(gradient)
        collectionView.backgroundView = bgView
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func refreshData() {
        viewModel.refresh()
    }
    
    private func bindViewModel() {
        viewModel.success = { [weak self] in
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.error = { errorMessage in
            print("Error: \(errorMessage)")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
        if indexPath.row < viewModel.photos.count,
           let url = viewModel.photos[indexPath.row].urls?.regular {
            cell.configure(imageURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.showWallpaperDetail(for: viewModel.photos[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.row)
    }
}

extension ListViewController {
    static func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(260)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(260)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 8)
            return section
        }
    }
}

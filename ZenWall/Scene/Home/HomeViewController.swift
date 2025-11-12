//
//  ViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 08.11.25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel = HomeViewModel()
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = HomeViewController.createLayout()
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchRandomPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup
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
    
    // MARK: - Binding
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
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1: return 1
        default: return viewModel.photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.onSearch = { [weak self] query in
                guard let self else { return }
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.viewModel.fetchRandomPhotos()
                } else {
                    self.viewModel.searchPhotos(query: query)
                }
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperOfDayCell", for: indexPath) as! WallpaperOfDayCell
            if indexPath.row < viewModel.photos.count {
                let url = viewModel.photoOfDay?.urls?.regular ?? ""
                cell.configure(imageURL: url)
            }
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
            if indexPath.row < viewModel.photos.count,
               let url = viewModel.photos[indexPath.row].urls?.regular {
                cell.configure(imageURL: url)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "HeaderCell",
            for: indexPath
        ) as! HeaderCell
        
        header.onSearch = { [weak self] query in
            guard let self else { return }
            
            if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.viewModel.fetchRandomPhotos()
            } else {
                self.viewModel.searchPhotos(query: query)
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.row)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension HomeViewController {
    static func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
                
            // MARK: - Section 0 → Header (ZenWall + Search)
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(120)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(120)
                    ),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
                return section
                
            // MARK: - Section 1 → Wallpaper of the Day
            case 1:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(220)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(220)
                    ),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
                return section
                
            // MARK: - Section 2 → Wallpapers Grid (2 sütunlu)
            default:
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
}

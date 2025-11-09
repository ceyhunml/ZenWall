//
//  HomeViewModel.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 08.11.25.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Properties
    private(set) var wallpapers: [String] = []
    
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private var isLoading = false
    private var currentPage = 1
    
    // MARK: - Mock Data (later Unsplash/Pexels API)
    func fetchWallpapers(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        
        if reset {
            wallpapers.removeAll()
            currentPage = 1
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            let newItems = [
                "https://images.unsplash.com/photo-1516117172878-fd2c41f4a759",
                "https://images.unsplash.com/photo-1532009324734-20a7a5813719",
                "https://images.unsplash.com/photo-1524429656589-6633a470097c",
                "https://images.unsplash.com/photo-1507149833265-60c372daea22",
                "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e",
                "https://images.unsplash.com/photo-1504208434309-cb69f4fe52b0"
            ]
            
            self.wallpapers.append(contentsOf: newItems)
            self.isLoading = false
            self.currentPage += 1
            
            DispatchQueue.main.async {
                self.onDataUpdate?()
            }
        }
    }
}

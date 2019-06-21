//
//  FirstViewController.swift
//  Moviepedia
//
//  Created by Tifo Audi Alif Putra on 20/06/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TrendingMovieVC: UIViewController {

    @IBOutlet weak var trendingMovieTableView: UITableView!
    private var movieViewModel = [MovieVM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieService.instance.fetchTrendingMovies(completion: { (response) in
            self.movieViewModel = response.results.map({ return MovieVM(movie: $0)})
            self.trendingMovieTableView.reloadData()
        }) { (error) in
            print(error)
        }
        
        self.setupTableView()
    }
    
    private func setupTableView() {
        trendingMovieTableView.tableFooterView = UIView()
        trendingMovieTableView.rowHeight = UITableView.automaticDimension
        trendingMovieTableView.estimatedRowHeight = 500
        trendingMovieTableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        trendingMovieTableView.delegate = self
        trendingMovieTableView.dataSource = self
    }
}

extension TrendingMovieVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return MovieCell() }
        let currentMovieViewModel = movieViewModel[indexPath.row]
        cell.setupCell(viewmodel: currentMovieViewModel)
        return cell
    }
}


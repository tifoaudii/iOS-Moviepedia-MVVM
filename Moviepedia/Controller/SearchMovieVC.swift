//
//  SecondViewController.swift
//  Moviepedia
//
//  Created by Tifo Audi Alif Putra on 20/06/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class SearchMovieVC: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    private weak var searchBar: UISearchBar!
    private var movieViewModel = [MovieVM]()
    private var movieService = MovieService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        
        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchBar = navigationItem.searchController?.searchBar
        self.searchBar.delegate = self
    }
    
    private func setupTableView() {
        searchTableView.tableFooterView = UIView()
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 500
        searchTableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.isHidden = true
    }

    private func searchMovieByQuery(withQuery query: String) {
        movieService.searchMovie(query: query, params: nil, successHandler: { (response) in
            self.movieViewModel = Array(response.results.prefix(5)).map({ return MovieVM(movie: $0) })
            self.searchTableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
}

extension SearchMovieVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return MovieCell() }
        let currentModelView = movieViewModel[indexPath.row]
        cell.setupCell(viewmodel: currentModelView)
        return cell
    }
}

extension SearchMovieVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.movieViewModel.removeAll()
        self.searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.movieViewModel.removeAll()
        self.searchTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let query = self.searchBar.text else { return }
        self.searchMovieByQuery(withQuery: query)
    }
   
}


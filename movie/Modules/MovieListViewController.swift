//
//  MovieListViewController.swift
//  movie
//
//  Created by Apit Gilang Aprida on 3/8/21.
//

import UIKit
import RxSwift

class MovieListViewController: UIViewController {

    var movieListViewViewModel: MovieListViewViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie List"
        navigationController?.navigationBar.prefersLargeTitles = true
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterMovie))
        navigationItem.setRightBarButton(filterButton, animated: false)
        movieListViewViewModel = MovieListViewViewModel(movieService: MovieService.shared)
        
        movieListViewViewModel.movies.drive(onNext: { [unowned self] (_) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
    }
    
    @objc private func filterMovie() {
        let alert = UIAlertController(title: "", message: "Please input the year.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Released year"
            textField.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.movieListViewViewModel.filterMovie(year: textField?.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Reset", style: .cancel, handler: { (_) in
            self.movieListViewViewModel.filterMovie(year: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewViewModel.numberOfMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        if let viewModel = movieListViewViewModel.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }
    
}

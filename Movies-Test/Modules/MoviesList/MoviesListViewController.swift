//
//  MoviesListViewController.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import UIKit

class MoviesListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            MovieCell.register(on: tableView)
        }
    }
    
    private var presenter: MoviesListPresenter

    // MARK: Object lifecycle
    init(presenter: MoviesListPresenter) {
        self.presenter = presenter
        super.init(nibName: "MoviesListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        tableView.dataSource = self
        tableView.delegate = self
        presenter.viewDelegate = self
        presenter.getMoviesList()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}


extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfMovies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        let movie = presenter.movies?[indexPath.row]
        
        cell.configure(name: movie?.title ?? "", releaseDate: movie?.releaseDate ?? "", image: movie?.poster ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = "\(presenter.movies?[indexPath.row].id ?? 0)"
        presenter.didSelectMovie(movieId: movieId)
    }
}

extension MoviesListViewController: MoviesListViewDelegate {
    func getMoviesListSuccessfully() {
        tableView.reloadData()
    }
    
    func getMoviesListFaild(message: String) {
        showMessage(message: message, messageType: .error)
    }
}

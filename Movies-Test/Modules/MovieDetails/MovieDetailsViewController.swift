//
//  MovieDetailsViewController.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageViewMoviePoster: UIImageView!
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var labelMovieReleaseDate: UILabel!
    @IBOutlet weak var labelMovieOverview: UILabel!
    
    private var presenter: MovieDetailsPresenter

    // MARK: Object lifecycle
    init(presenter: MovieDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: "MovieDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDelegate = self
        presenter.getMovieDetails()
    }
    
    private func setUpData() {
        if let imagePath = presenter.movieDetails?.posterPath, let url = URL(string: moviePosterRoot + imagePath) {
            imageViewMoviePoster.kf.setImage(with: url)
        }
        labelMovieName.text = presenter.movieDetails?.title ?? ""
        labelMovieReleaseDate.text = presenter.movieDetails?.releaseDate ?? ""
        labelMovieOverview.text = presenter.movieDetails?.overview ?? ""
    }
}

extension MovieDetailsViewController: MovieDetailsViewDelegate {
    func getMovieDetailsSuccessfully() {
        setUpData()
    }
    
    func getMovieDetailsFaild(message: String) {
        showMessage(message: message, messageType: .error)
    }
}

//
//  LocationSearchViewController.swift
//  Xebia
//
//  Created by Muhammad Farooq on 14/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var presenter: LocationSearchViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.layer.cornerRadius = 8
        
        presenter = LocationSearchViewPresenter(view: self)
        weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        locationSearchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func showError(_ error: String) {
    }
    
    private func hideError() {
    }
    
    private func activityIndicatorAnimating(_ animating: Bool ) {
        animating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    // MARK: - UISearchBar methods
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let locations =  searchBar.text?.components(separatedBy:",") else {
            return true
        }
        
        if (locations.count > Constants.MAX_LOC) {
            return false
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        locationSearchBar.endEditing(true)
        locationSearchBar.resignFirstResponder()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchCity(text: searchBar.text)
        locationSearchBar.endEditing(true)
        locationSearchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension LocationSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.locationCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? WeatherTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WeatherTableViewCell")
        }
        
        cell.setupCell(w: presenter.getWeatherAtIndex(index: indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - LocationSearchView protocol methods
extension LocationSearchViewController: LocationSearchView {
    
    func reloadView() {
        self.weatherTableView.reloadData()
    }
    
    func showErrorView(_ error: String) {
        self.showError(error)
    }
    
    func hideErrorView() {
        self.hideError()
    }
    
    func activityIndicatorAnimatingView(animating: Bool) {
        activityIndicatorAnimating(animating)
    }
}

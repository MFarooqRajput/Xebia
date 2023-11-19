//
//  ViewController.swift
//  Weather
//
//  Created by Muhammad Farooq on 12/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var locationCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let locationManager = CLLocationManager()
    var presenter: WeattherViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WeattherViewPresenter(view: self)
        
        locationCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        // location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        getLocation()
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
    
    private func updateBackgroundImage(_ image: String) {
        if(image.isEmpty) {
            
        } else {
            backgroundImageView.image = UIImage(named: image)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? LocationCollectionViewCell else {
            fatalError("The deque cell is not an instance of LocationCollectionViewCell.")
        }
        
        cell.setupCell(w: presenter.getWeather())
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
}

// MARK: - LocationView protocol methods
extension WeatherViewController: WeattherView {
    
    func reloadView() {
        locationCollectionView.reloadData()
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
    
    func updateBackgroundImageView(_ image: String) {
        updateBackgroundImage(image)
    }
}

// MARK: - CLLocation
extension WeatherViewController {
    
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
    }

    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            debugPrint("Denied")
        case .restricted:
            debugPrint("Restricted")
        @unknown default:
            debugPrint("Unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getLocation()
    }
    
    func getWeatherForCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            presenter.param = "&lat=\(latitude)&lon=\(longitude)"
            presenter.fetchWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //ERROR
    }
    
}

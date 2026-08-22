import UIKit
import MapKit
import SnapKit
import CoreLocation

final class WeatherMapViewController: UIViewController {
    
    private let mapView = MKMapView()
    
    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.addTarget(self, action: #selector(centerMap), for: .touchUpInside)
        return button
    }()
    
    private let weatherCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.isHidden = true
        return view
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .thin)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loader = UIActivityIndicatorView(style: .medium)
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Нажмите на карту,\nчтобы узнать погоду"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.15, green: 0.30, blue: 0.70, alpha: 0.8)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    private let weatherService = WeatherService()
    private var selectedAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
}

private extension WeatherMapViewController {
    
    func setupUI() {
        setupGradient()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tap)
        
        setupSubviews()
        setupConstraints()
    }
    
    func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.15, green: 0.30, blue: 0.70, alpha: 1.0).cgColor,
            UIColor(red: 0.35, green: 0.15, blue: 0.55, alpha: 1.0).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    func setupSubviews() {
        view.addSubview(mapView)
        view.addSubview(locationButton)
        view.addSubview(weatherCard)
        view.addSubview(hintLabel)
        
        weatherCard.addSubview(cityLabel)
        weatherCard.addSubview(tempLabel)
        weatherCard.addSubview(descriptionLabel)
        weatherCard.addSubview(iconView)
        weatherCard.addSubview(loader)
        
        loader.hidesWhenStopped = true
    }
    
    func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(50)
        }
        
        weatherCard.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(tempLabel.snp.trailing).offset(12)
            make.bottom.equalTo(tempLabel)
        }
        
        iconView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalTo(iconView)
        }
        
        hintLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
    }
    
    @objc func mapTapped(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        if let existing = selectedAnnotation {
            mapView.removeAnnotation(existing)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        selectedAnnotation = annotation
        
        loadWeather(at: coordinate)
        
        weatherCard.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        weatherCard.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.weatherCard.transform = .identity
            self.weatherCard.alpha = 1
        }
    }
    
    func loadWeather(at coordinate: CLLocationCoordinate2D) {
        weatherCard.isHidden = false
        cityLabel.text = "Загрузка..."
        tempLabel.text = ""
        descriptionLabel.text = ""
        iconView.isHidden = true
        loader.startAnimating()
        hintLabel.isHidden = true
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            let cityName = placemarks?.first?.locality
            ?? placemarks?.first?.name
            ?? "Выбранная точка"
            
            DispatchQueue.main.async {
                self?.cityLabel.text = cityName
            }
        }
        
        weatherService.fetchCurrentWeather(lat: coordinate.latitude, lon: coordinate.longitude) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                self.loader.stopAnimating()
                self.iconView.isHidden = false
                
                switch result {
                case .success(let weather):
                    let viewModel = WeatherViewModel(from: weather)
                    self.cityLabel.text = viewModel.city
                    self.tempLabel.text = viewModel.temperature
                    self.descriptionLabel.text = viewModel.description
                    self.iconView.image = UIImage(systemName: viewModel.icon)
                    self.selectedAnnotation?.title = viewModel.city
                    
                case .failure:
                    self.tempLabel.text = "—"
                    self.descriptionLabel.text = "Ошибка загрузки"
                    self.iconView.image = UIImage(systemName: "exclamationmark.triangle")
                }
            }
        }
    }
    
    @objc func centerMap() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
}

extension WeatherMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "WeatherPin"
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        view.annotation = annotation
        view.markerTintColor = .systemBlue
        view.glyphImage = UIImage(systemName: "cloud.fill")
        view.animatesWhenAdded = true
        return view
    }
}

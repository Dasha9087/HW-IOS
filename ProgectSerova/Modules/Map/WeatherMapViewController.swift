import UIKit
import MapKit

final class WeatherMapViewController: UIViewController {
    
    private let mainView = WeatherMapView()
    private let presenter: WeatherMapPresenter
    private var selectedAnnotation: MKPointAnnotation?
    
    init(presenter: WeatherMapPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        mainView.mapView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mainView.mapView.addGestureRecognizer(tap)
        mainView.locationButton.addTarget(self, action: #selector(centerMap), for: .touchUpInside)
    }
    
    @objc private func mapTapped(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mainView.mapView)
        let coordinate = mainView.mapView.convert(point, toCoordinateFrom: mainView.mapView)
        
        // Обновляем маркер
        if let existing = selectedAnnotation { mainView.mapView.removeAnnotation(existing) }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mainView.mapView.addAnnotation(annotation)
        selectedAnnotation = annotation
        
        presenter.handleMapTap(coordinate: coordinate)
    }
    
    @objc private func centerMap() {
        mainView.mapView.setUserTrackingMode(.follow, animated: true)
    }
}

extension WeatherMapViewController: WeatherMapViewInput {
    func showError(message: String) {
        mainView.loader.stopAnimating()
        mainView.tempLabel.text = "-"
        mainView.descriptionLabel.text = message
    }
    
    func showLoading() {
        mainView.showLoading()
    }
    
    func update(with viewModel: WeatherViewModel) {
        mainView.update(with: viewModel)
        selectedAnnotation?.title = viewModel.city
    }
    
    func showError() {
        mainView.loader.stopAnimating()
        mainView.tempLabel.text = "—"
        mainView.descriptionLabel.text = "Ошибка"
    }
}

extension WeatherMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        view.markerTintColor = .systemBlue
        return view
    }
}

import UIKit
import MapKit
import SnapKit

final class WeatherMapView: UIView {
    
    let mapView = MKMapView()
    
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        return button
    }()
    
    let weatherCard: UIView = {
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
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .thin)
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let loader = UIActivityIndicatorView(style: .medium)
    
    let hintLabel: UILabel = {
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
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.15, green: 0.30, blue: 0.70, alpha: 1.0).cgColor,
            UIColor(red: 0.35, green: 0.15, blue: 0.55, alpha: 1.0).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func showLoading() {
        weatherCard.isHidden = false
        cityLabel.text = "Загрузка..."
        tempLabel.text = ""
        descriptionLabel.text = ""
        iconView.isHidden = true
        loader.startAnimating()
        hintLabel.isHidden = true
    }
    
    func update(with viewModel: WeatherViewModel) {
        loader.stopAnimating()
        iconView.isHidden = false
        cityLabel.text = viewModel.city
        tempLabel.text = viewModel.temperature
        descriptionLabel.text = viewModel.description
        iconView.image = UIImage(systemName: viewModel.icon)
    }
    
    func showError(message: String) {
        loader.stopAnimating()
        cityLabel.text = "Ошибка"
        tempLabel.text = "—"
        descriptionLabel.text = message
        iconView.isHidden = false
        iconView.image = UIImage(systemName: "exclamationmark.triangle")
    }
}

private extension WeatherMapView {
    func setupUI() {
        layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(mapView)
        addSubview(locationButton)
        addSubview(weatherCard)
        addSubview(hintLabel)
        
        weatherCard.addSubview(cityLabel)
        weatherCard.addSubview(tempLabel)
        weatherCard.addSubview(descriptionLabel)
        weatherCard.addSubview(iconView)
        weatherCard.addSubview(loader)
        
        loader.hidesWhenStopped = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(50)
        }
        
        weatherCard.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
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
}

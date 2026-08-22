import UIKit
import SnapKit

final class DayDetailsViewController: UIViewController {
    
    private let presenter: DayDetailsPresenter
    private let forecastItem: ForecastItem
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentView = UIView()
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        return label
    }()
    
    private let chartCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Температура по часам"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private let chartView = UIView()
    private let detailsGrid = UIView()
    private var detailLabels: [UILabel] = []
    private var gradientLayer: CAGradientLayer?
    private var lastViewModel: DayDetailsViewModel?
    
    init(presenter: DayDetailsPresenter, item: ForecastItem) {
        self.presenter = presenter
        self.forecastItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.view = self
        presenter.loadDetails(for: forecastItem)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        if let viewModel = lastViewModel {
            drawChart(temps: viewModel.hourlyTemps)
        }
    }
}

private extension DayDetailsViewController {
    
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
        
        setupScrollView()
        setupContainer()
        setupHeader()
        setupChart()
        setupDetailsGrid()
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
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
        }
    }
    
    func setupContainer() {
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    func setupHeader() {
        containerView.addSubview(cityLabel)
        containerView.addSubview(dateLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupChart() {
        containerView.addSubview(chartCard)
        chartCard.addSubview(chartTitleLabel)
        chartCard.addSubview(chartView)
        
        chartCard.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(220)
        }
        
        chartTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(chartTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        chartView.backgroundColor = .clear
    }
    
    func setupDetailsGrid() {
        containerView.addSubview(detailsGrid)
        
        detailsGrid.snp.makeConstraints { make in
            make.top.equalTo(chartCard.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        let itemData: [(String, String)] = [
            ("sunrise.fill", "Восход"),
            ("sunset.fill", "Закат"),
            ("gauge", "Давление"),
            ("humidity.fill", "Влажность"),
            ("eye.fill", "Видимость"),
            ("wind", "Ветер"),
            ("thermometer.medium", "Ощущается")
        ]
        
        let screenWidth = UIScreen.main.bounds.width - 64
        let itemWidth = screenWidth / 2 - 8
        let itemHeight: CGFloat = 75
        let verticalSpacing: CGFloat = 12
        
        var lastRowView: UIView?
        
        for (index, data) in itemData.enumerated() {
            let container = UIView()
            container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            container.layer.cornerRadius = 12
            
            let iconView = UIImageView(image: UIImage(systemName: data.0))
            iconView.tintColor = .white
            iconView.contentMode = .scaleAspectFit
            
            let titleLabel = UILabel()
            titleLabel.text = data.1
            titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
            titleLabel.textColor = .white.withAlphaComponent(0.7)
            
            let valueLabel = UILabel()
            valueLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            valueLabel.textColor = .white
            valueLabel.text = "--"
            valueLabel.numberOfLines = 1
            
            detailsGrid.addSubview(container)
            container.addSubview(iconView)
            container.addSubview(titleLabel)
            container.addSubview(valueLabel)
            
            let row = index / 2
            let col = index % 2
            
            container.snp.makeConstraints { make in
                make.width.equalTo(itemWidth)
                make.height.equalTo(itemHeight)
                
                if col == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalToSuperview().offset(itemWidth + 8)
                }
                
                if row == 0 {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(lastRowView!.snp.bottom).offset(verticalSpacing)
                }
            }
            
            if col == 1 || index == itemData.count - 1 {
                lastRowView = container
            }
            
            iconView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalToSuperview().offset(14)
                make.size.equalTo(20)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(iconView.snp.trailing).offset(8)
                make.centerY.equalTo(iconView)
            }
            
            valueLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(14)
                make.bottom.equalToSuperview().inset(12)
                make.trailing.equalToSuperview().inset(8)
            }
            
            detailLabels.append(valueLabel)
        }
        
        if let bottomView = lastRowView {
            bottomView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
            }
        }
    }
    
    func drawChart(temps: [Int]) {
        chartView.subviews.forEach { $0.removeFromSuperview() }
        
        guard temps.count > 1 else {
            let label = UILabel()
            label.text = "Нет данных"
            label.textColor = .white.withAlphaComponent(0.6)
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textAlignment = .center
            chartView.addSubview(label)
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return
        }
        
        let chartWidth = chartView.bounds.width
        let chartHeight = chartView.bounds.height
        
        guard chartWidth > 0 && chartHeight > 0 else { return }
        
        let maxValue = (temps.max() ?? 30) + 5
        let minValue = (temps.min() ?? 10) - 5
        let range = max(CGFloat(maxValue - minValue), 10)
        
        let padding: CGFloat = 20
        let topPadding: CGFloat = 10
        let bottomPadding: CGFloat = 30
        let availableHeight = chartHeight - topPadding - bottomPadding
        let availableWidth = chartWidth - padding * 2
        
        var points: [CGPoint] = []
        
        for (index, temp) in temps.enumerated() {
            let x = padding + (CGFloat(index) / CGFloat(temps.count - 1)) * availableWidth
            let y = topPadding + availableHeight - (CGFloat(temp - minValue) / range * availableHeight)
            points.append(CGPoint(x: x, y: y))
        }
        
        if points.count > 1 {
            let path = UIBezierPath()
            path.move(to: points[0])
            for i in 1..<points.count {
                path.addLine(to: points[i])
            }
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = UIColor.white.cgColor
            lineLayer.lineWidth = 2.5
            lineLayer.fillColor = nil
            lineLayer.lineCap = .round
            lineLayer.lineJoin = .round
            chartView.layer.addSublayer(lineLayer)
            
            let fillPath = UIBezierPath()
            fillPath.move(to: CGPoint(x: padding, y: chartHeight - bottomPadding))
            fillPath.addLine(to: points[0])
            for point in points {
                fillPath.addLine(to: point)
            }
            fillPath.addLine(to: CGPoint(x: padding + availableWidth, y: chartHeight - bottomPadding))
            fillPath.close()
            
            let fillLayer = CAShapeLayer()
            fillLayer.path = fillPath.cgPath
            fillLayer.fillColor = UIColor.white.withAlphaComponent(0.15).cgColor
            fillLayer.strokeColor = nil
            chartView.layer.insertSublayer(fillLayer, at: 0)
        }
        
        for (index, temp) in temps.enumerated() {
            let point = points[index]
            
            let dot = UIView()
            dot.backgroundColor = .white
            dot.layer.cornerRadius = 5
            dot.layer.shadowColor = UIColor.white.cgColor
            dot.layer.shadowOpacity = 0.3
            dot.layer.shadowRadius = 4
            
            chartView.addSubview(dot)
            dot.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(point.x - chartWidth / 2)
                make.centerY.equalToSuperview().offset(point.y - chartHeight / 2)
                make.size.equalTo(10)
            }
            
            let tempLabel = UILabel()
            tempLabel.text = "\(temp)°"
            tempLabel.font = .systemFont(ofSize: 10, weight: .medium)
            tempLabel.textColor = .white.withAlphaComponent(0.8)
            tempLabel.textAlignment = .center
            
            chartView.addSubview(tempLabel)
            tempLabel.snp.makeConstraints { make in
                make.centerX.equalTo(dot)
                make.top.equalTo(dot.snp.bottom).offset(4)
            }
            
            if index % 2 == 0 || index == temps.count - 1 {
                let timeLabel = UILabel()
                let hour = (8 + index) % 24
                timeLabel.text = String(format: "%02d:00", hour)
                timeLabel.font = .systemFont(ofSize: 9, weight: .regular)
                timeLabel.textColor = .white.withAlphaComponent(0.4)
                timeLabel.textAlignment = .center
                
                chartView.addSubview(timeLabel)
                timeLabel.snp.makeConstraints { make in
                    make.centerX.equalTo(dot)
                    make.top.equalTo(tempLabel.snp.bottom).offset(2)
                }
            }
        }
    }
}

extension DayDetailsViewController: DayDetailsViewProtocol {
    
    func renderDetails(_ viewModel: DayDetailsViewModel) {
        lastViewModel = viewModel
        
        cityLabel.text = viewModel.city
        
        let dateOnly = viewModel.date.components(separatedBy: " ").first ?? viewModel.date
        dateLabel.text = dateOnly
        
        let values = [
            viewModel.sunrise,
            viewModel.sunset,
            viewModel.pressure,
            viewModel.humidity,
            viewModel.visibility,
            viewModel.windSpeed,
            viewModel.feelsLike
        ]
        
        for (index, label) in detailLabels.enumerated() {
            if index < values.count {
                label.text = values[index]
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.drawChart(temps: viewModel.hourlyTemps)
        }
    }
}

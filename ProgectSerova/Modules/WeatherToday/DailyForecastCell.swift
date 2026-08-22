import UIKit
import SnapKit

final class DailyForecastCell: UITableViewCell {
    
    static let identifier = "DailyForecastCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .white.withAlphaComponent(0.4)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ForecastItem) {
        dayLabel.text = dayTitle(for: item.dt)
        tempLabel.text = UnitsFormatter.temperature(item.main.temp)
        
        let iconCode = item.weather.first?.icon ?? "01d"
        iconView.image = UIImage(systemName: WeatherIcon.systemName(for: iconCode))
    }
}

private extension DailyForecastCell {
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        containerView.addSubview(dayLabel)
        containerView.addSubview(iconView)
        containerView.addSubview(tempLabel)
        containerView.addSubview(arrowImageView)
        
        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(28)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
    }
    
    func dayTitle(for timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Сегодня"
        }
        
        if calendar.isDateInTomorrow(date) {
            return "Завтра"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}

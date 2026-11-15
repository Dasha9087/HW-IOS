import UIKit
import SnapKit

final class CreateAdViewController: UIViewController {
    private let presenter: CreateAdPresenter
    var onPublished: (() -> Void)?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let formStackView = UIStackView()

    private let headerEyebrowLabel = UILabel()
    private let headerLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let formCardView = UIView()
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()

    private let categoryButton = UIButton(type: .system)
    private let categoryTitleLabel = UILabel()
    private let categoryChevron = UIImageView(
        image: UIImage(systemName: "chevron.down")
    )
    private var selectedCategory: AdCategory?

    private let priceTextField = UITextField()

    private let cityButton = UIButton(type: .system)
    private let cityTitleLabel = UILabel()
    private let cityChevron = UIImageView(
        image: UIImage(systemName: "chevron.down")
    )
    private var selectedCity: String?

    private let publishButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let descriptionPlaceholder = "Описание объявления"
    private var isDescriptionPlaceholderVisible = true

    init(
        adsService: AdsServiceable = AdsService(),
        authService: AuthServiceable = AuthService()
    ) {
        self.presenter = CreateAdPresenter(
            adsService: adsService,
            authService: authService
        )

        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.catalogBackground
        title = "Разместить объявление"

        setupUI()
    }

    private func setupUI() {
        headerEyebrowLabel.text = "НОВОЕ ОБЪЯВЛЕНИЕ"
        headerEyebrowLabel.font = .systemFont(ofSize: 11, weight: .bold)
        headerEyebrowLabel.textColor = AppColors.orange

        headerLabel.text = "Расскажите, что продаёте"
        headerLabel.font = .systemFont(ofSize: 26, weight: .bold)
        headerLabel.textColor = AppColors.textPrimary
        headerLabel.numberOfLines = 0

        subtitleLabel.text = "Укажите основные детали, чтобы покупателю было проще найти ваше объявление."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = AppColors.textSecondary
        subtitleLabel.numberOfLines = 0

        formCardView.backgroundColor = AppColors.cardBackground
        formCardView.layer.cornerRadius = 20
        formCardView.layer.borderWidth = 1
        formCardView.layer.borderColor = AppColors.border.cgColor

        configureTextField(
            titleTextField,
            placeholder: "Название объявления"
        )
        titleTextField.returnKeyType = .next
        titleTextField.delegate = self

        descriptionTextView.text = descriptionPlaceholder
        descriptionTextView.textColor = AppColors.textSecondary
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.backgroundColor = AppColors.catalogBackground
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = AppColors.border.cgColor
        descriptionTextView.layer.cornerRadius = 14
        descriptionTextView.layer.cornerCurve = .continuous
        descriptionTextView.textContainerInset = UIEdgeInsets(
            top: 12,
            left: 12,
            bottom: 12,
            right: 12
        )
        descriptionTextView.delegate = self

        configureSelectionButton(
            categoryButton,
            titleLabel: categoryTitleLabel,
            chevron: categoryChevron,
            placeholder: "Выберите категорию"
        )
        categoryButton.addTarget(
            self,
            action: #selector(selectCategoryTapped),
            for: .touchUpInside
        )

        configureTextField(priceTextField, placeholder: "Цена, р.")
        priceTextField.keyboardType = .numberPad

        configureSelectionButton(
            cityButton,
            titleLabel: cityTitleLabel,
            chevron: cityChevron,
            placeholder: "Город"
        )
        cityButton.addTarget(
            self,
            action: #selector(selectCityTapped),
            for: .touchUpInside
        )

        publishButton.setTitle("Опубликовать", for: .normal)
        publishButton.setTitleColor(.white, for: .normal)
        publishButton.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        publishButton.backgroundColor = AppColors.orange
        publishButton.layer.cornerRadius = 16
        publishButton.layer.cornerCurve = .continuous
        publishButton.addTarget(
            self,
            action: #selector(publishButtonTapped),
            for: .touchUpInside
        )

        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true

        formStackView.axis = .vertical
        formStackView.spacing = 12
        formStackView.alignment = .fill

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill

        scrollView.keyboardDismissMode = .interactive

        setupLayout()
    }

    private func configureTextField(
        _ textField: UITextField,
        placeholder: String
    ) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: AppColors.textSecondary]
        )
        textField.textColor = AppColors.textPrimary
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = AppColors.catalogBackground
        textField.layer.borderWidth = 1
        textField.layer.borderColor = AppColors.border.cgColor
        textField.layer.cornerRadius = 14
        textField.layer.cornerCurve = .continuous
        textField.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 14, height: 1)
        )
        textField.leftViewMode = .always
    }

    private func configureSelectionButton(
        _ button: UIButton,
        titleLabel: UILabel,
        chevron: UIImageView,
        placeholder: String
    ) {
        button.backgroundColor = AppColors.catalogBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColors.border.cgColor
        button.layer.cornerRadius = 14
        button.layer.cornerCurve = .continuous
        button.clipsToBounds = true

        titleLabel.text = placeholder
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = AppColors.textSecondary
        titleLabel.lineBreakMode = .byTruncatingTail

        chevron.tintColor = AppColors.textSecondary
        chevron.contentMode = .scaleAspectFit
        chevron.isUserInteractionEnabled = false

        button.addSubview(titleLabel)
        button.addSubview(chevron)
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(headerEyebrowLabel)
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(formCardView)
        stackView.addArrangedSubview(publishButton)

        formCardView.addSubview(formStackView)
        formStackView.addArrangedSubview(titleTextField)
        formStackView.addArrangedSubview(descriptionTextView)
        formStackView.addArrangedSubview(categoryButton)
        formStackView.addArrangedSubview(priceTextField)
        formStackView.addArrangedSubview(cityButton)

        publishButton.addSubview(activityIndicator)

        categoryTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalTo(categoryChevron.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        categoryChevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }

        cityTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalTo(cityChevron.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        cityChevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)
            )
        }

        formStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(14)
        }

        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }

        categoryButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        priceTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        cityButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        publishButton.snp.makeConstraints { make in
            make.height.equalTo(54)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func updateSelectionTitle(
        _ title: String,
        label: UILabel,
        isSelected: Bool
    ) {
        label.text = title
        label.textColor = isSelected
            ? AppColors.textPrimary
            : AppColors.textSecondary
    }

    @objc private func selectCategoryTapped() {
        let picker = CategoryPickerViewController(
            selectedCategory: selectedCategory
        ) { [weak self] category in
            self?.presenter.selectCategory(category)
        }

        present(picker, animated: true)
    }

    @objc private func selectCityTapped() {
        let picker = CityPickerViewController(
            selectedCity: selectedCity
        ) { [weak self] city in
            guard let self = self else { return }

            self.selectedCity = city
            self.updateSelectionTitle(
                city,
                label: self.cityTitleLabel,
                isSelected: true
            )
        }

        present(picker, animated: true)
    }

    @objc private func publishButtonTapped() {
        view.endEditing(true)

        let description = isDescriptionPlaceholderVisible
            ? ""
            : descriptionTextView.text ?? ""

        presenter.createAd(
            title: titleTextField.text ?? "",
            description: description,
            price: priceTextField.text ?? "",
            city: selectedCity ?? ""
        )
    }

    private func resetForm() {
        titleTextField.text = ""
        priceTextField.text = ""

        selectedCategory = nil
        updateSelectionTitle(
            "Выберите категорию",
            label: categoryTitleLabel,
            isSelected: false
        )

        selectedCity = nil
        updateSelectionTitle(
            "Город",
            label: cityTitleLabel,
            isSelected: false
        )

        isDescriptionPlaceholderVisible = true
        descriptionTextView.text = descriptionPlaceholder
        descriptionTextView.textColor = AppColors.textSecondary
    }
}

extension CreateAdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === titleTextField {
            descriptionTextView.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}

extension CreateAdViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard isDescriptionPlaceholderVisible else { return }

        isDescriptionPlaceholderVisible = false
        textView.text = ""
        textView.textColor = AppColors.textPrimary
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            return
        }

        isDescriptionPlaceholderVisible = true
        textView.text = descriptionPlaceholder
        textView.textColor = AppColors.textSecondary
    }
}

// MARK: - CreateAdViewInput
extension CreateAdViewController: CreateAdViewInput {
    func showLoading(_ isLoading: Bool) {
        publishButton.isEnabled = !isLoading

        if isLoading {
            publishButton.setTitle(nil, for: .normal)
            activityIndicator.startAnimating()
        } else {
            publishButton.setTitle("Опубликовать", for: .normal)
            activityIndicator.stopAnimating()
        }
    }

    func modelUpdated(category: AdCategory?) {
        selectedCategory = category

        if let category {
            updateSelectionTitle(
                category.rawValue,
                label: categoryTitleLabel,
                isSelected: true
            )
        } else {
            updateSelectionTitle(
                "Выберите категорию",
                label: categoryTitleLabel,
                isSelected: false
            )
        }
    }

    func showError(with message: String) {
        let alert = UIAlertController(
            title: "Сообщение",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }

    func didCreateAd() {
        resetForm()

        let alert = UIAlertController(
            title: "Готово",
            message: "Объявление опубликовано.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
                self?.onPublished?()
            }
        )

        present(alert, animated: true)
    }
}

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let sizes = [
        "Маленькая 25см",
        "Средняя 30см",
        "Большая 35см",
        "Семейная 45см"
    ]

    private let doughTypes = [
        "Тонкое",
        "Традиционное",
        "Пышное",
        "Сырный бортик"
    ]

    private let cities = [
        "Москва",
        "Санкт-Петербург",
        "Казань",
        "Новосибирск"
    ]

    private var selectedSize: String?
    private var selectedDough: String?
    private var selectedCity: String?
    private var toppings: [String] = []
    private var receiptImage: UIImage?
    private var activeField: UITextField?

    private let sizeField = UITextField()
    private let doughField = UITextField()
    private let cityField = UITextField()
    private let pickerView = UIPickerView()

    private let toppingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать топпинги", for: .normal)
        return button
    }()

    private let toppingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Без топпингов"
        label.numberOfLines = 0
        return label
    }()

    private let receiptImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.systemGray5
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let receiptLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавьте фото чека"
        label.textAlignment = .center
        return label
    }()

    private let receiptStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemGreen
        label.isHidden = true
        return label
    }()

    private let orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оформить заказ", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let section1View = UIView()
    private let section2View = UIView()
    private let section3View = UIView()
    
    private let mainBackground = UIColor(red: 255/255, green: 248/255, blue: 240/255, alpha: 1)
    private let accentColor = UIColor(red: 255/255, green: 94/255, blue: 58/255, alpha: 1)
    private let secondaryAccent = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupFields()
        setupUI()
        setupPicker()
        setupToolbar()

        toppingsButton.addTarget(self, action: #selector(openToppings), for: .touchUpInside)
        orderButton.addTarget(self, action: #selector(makeOrder), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(receiptTapped))
        receiptImageView.addGestureRecognizer(tap)
    }

    private func setupFields() {
        [sizeField, doughField, cityField].forEach {
            $0.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 235/255, alpha: 1)
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = accentColor.cgColor
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
            $0.leftViewMode = .always
        }

        sizeField.placeholder = "Выберите размер"
        doughField.placeholder = "Выберите тесто"
        cityField.placeholder = "Выберите город"
    }

    private func setupUI() {

        view.backgroundColor = mainBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        [section1View, section2View, section3View, orderButton].forEach {
            contentView.addSubview($0)
        }

        styleCard(section1View)
        styleCard(section2View)
        styleCard(section3View)

        section1View.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        let title1 = makeSectionTitle("🍕 Параметры пиццы")
        section1View.addSubview(title1)
        section1View.addSubview(sizeField)
        section1View.addSubview(doughField)
        section1View.addSubview(cityField)

        title1.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }

        sizeField.snp.makeConstraints {
            $0.top.equalTo(title1.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        doughField.snp.makeConstraints {
            $0.top.equalTo(sizeField.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        cityField.snp.makeConstraints {
            $0.top.equalTo(doughField.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        section2View.snp.makeConstraints {
            $0.top.equalTo(section1View.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        let title2 = makeSectionTitle("🧀 Топпинги")
        section2View.addSubview(title2)
        section2View.addSubview(toppingsButton)
        section2View.addSubview(toppingsLabel)

        title2.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }

        toppingsButton.snp.makeConstraints {
            $0.top.equalTo(title2.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        toppingsLabel.snp.makeConstraints {
            $0.top.equalTo(toppingsButton.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }

        section3View.snp.makeConstraints {
            $0.top.equalTo(section2View.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        let title3 = makeSectionTitle("📸 Фото чека")
        section3View.addSubview(title3)
        section3View.addSubview(receiptImageView)
        section3View.addSubview(receiptLabel)
        section3View.addSubview(receiptStatusLabel)

        title3.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }

        receiptImageView.snp.makeConstraints {
            $0.top.equalTo(title3.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(160)
        }

        receiptLabel.snp.makeConstraints {
            $0.top.equalTo(receiptImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        receiptStatusLabel.snp.makeConstraints {
            $0.top.equalTo(receiptLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }

        orderButton.snp.makeConstraints {
            $0.top.equalTo(section3View.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(55)
            $0.bottom.equalToSuperview().inset(30)
        }

        styleOrderButton()
    }


    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self

        sizeField.inputView = pickerView
        doughField.inputView = pickerView
        cityField.inputView = pickerView

        sizeField.addTarget(self, action: #selector(fieldEditing(_:)), for: .editingDidBegin)
        doughField.addTarget(self, action: #selector(fieldEditing(_:)), for: .editingDidBegin)
        cityField.addTarget(self, action: #selector(fieldEditing(_:)), for: .editingDidBegin)
    }

    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let done = UIBarButtonItem(
            title: "Готово",
            style: .plain,
            target: self,
            action: #selector(doneTapped)
        )

        toolbar.setItems([done], animated: false)

        sizeField.inputAccessoryView = toolbar
        doughField.inputAccessoryView = toolbar
        cityField.inputAccessoryView = toolbar
    }
    
    private func currentPickerData() -> [String] {
        if activeField == sizeField { return sizes }
        if activeField == doughField { return doughTypes }
        return cities
    }

    @objc private func fieldEditing(_ textField: UITextField) {
        activeField = textField
        pickerView.reloadAllComponents()
    }

    @objc private func doneTapped() {
        view.endEditing(true)
    }
    
    @objc private func openToppings() {
        let alert = UIAlertController(title: "Топпинги", message: nil, preferredStyle: .alert)

        for i in 0..<5 {
            alert.addTextField {
                $0.placeholder = "Топпинг \(i + 1)"
                if i < self.toppings.count {
                    $0.text = self.toppings[i]
                }
            }
        }

        alert.addAction(UIAlertAction(title: "Готово", style: .default) { _ in
            self.toppings = alert.textFields?
                .compactMap { $0.text }
                .filter { !$0.isEmpty } ?? []

            self.toppingsLabel.text = self.toppings.isEmpty
                ? "Без топпингов"
                : self.toppings.joined(separator: ", ")
        })

        present(alert, animated: true)
    }

    @objc private func receiptTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.openCamera()
        })

        sheet.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
            self.openGallery()
        })

        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        present(sheet, animated: true)
    }

    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(message: "Камера недоступна на этом устройстве")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    private func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(message: "Галерея недоступна")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func makeOrder() {
        guard let size = selectedSize else {
            showAlert(message: "Выберите размер")
            return
        }

        guard let dough = selectedDough else {
            showAlert(message: "Выберите тесто")
            return
        }

        guard let city = selectedCity else {
            showAlert(message: "Выберите город")
            return
        }

        let price = calculatePrice()

        let toppingsText = toppings.isEmpty
            ? "Без топпингов"
            : toppings.joined(separator: ", ")

        let photoText = receiptImage == nil ? "Нет" : "Есть"

        let message = """
        Размер: \(size)
        Тесто: \(dough)
        Топпинги: \(toppingsText)
        Город: \(city)
        Фото: \(photoText)
        Цена: \(price)₽
        """

        let sheet = UIAlertController(title: "Ваш заказ", message: message, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Подтвердить заказ", style: .default) { _ in

            if price > 1000 {
                self.showFinalAlert(title: "Поздравляем!", message: "Вам доступна бесплатная доставка")
            } else {
                self.showFinalAlert(title: "Заказ оформлен", message: "Спасибо за заказ!")
            }
            
            self.resetForm()
        })

        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        present(sheet, animated: true)
    }

    private func calculatePrice() -> Int {
        let basePrices: [String: Int] = [
            sizes[0]: 400,
            sizes[1]: 600,
            sizes[2]: 800,
            sizes[3]: 1100
        ]

        var price = basePrices[selectedSize ?? ""] ?? 0
        price += toppings.count * 50

        if selectedDough == "Сырный бортик" {
            price += 150
        }

        return price
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showFinalAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func resetForm() {
        sizeField.text = nil
        doughField.text = nil
        cityField.text = nil
        toppingsLabel.text = "Без топпингов"
        receiptImageView.image = nil
        receiptStatusLabel.isHidden = true

        selectedSize = nil
        selectedDough = nil
        selectedCity = nil
        toppings = []
        receiptImage = nil
    }
    
    private func styleCard(_ view: UIView) {
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 12
    }
    
    private func makeSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    private func styleOrderButton() {
        orderButton.layer.cornerRadius = 18
        orderButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        orderButton.clipsToBounds = true

        let gradient = CAGradientLayer()
        gradient.colors = [secondaryAccent.cgColor, accentColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 55)

        orderButton.layer.insertSublayer(gradient, at: 0)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currentPickerData().count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentPickerData()[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let value = currentPickerData()[row]
        activeField?.text = value

        if activeField == sizeField { selectedSize = value }
        if activeField == doughField { selectedDough = value }
        if activeField == cityField { selectedCity = value }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            receiptImage = image
            receiptImageView.image = image
            receiptStatusLabel.text = "Фото добавлено"
            receiptStatusLabel.isHidden = false
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

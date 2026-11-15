//
//  CategoryPickerViewController.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import UIKit
import SnapKit

final class CategoryPickerViewController: UIViewController {
    private let categories = AdCategory.allCases
    private let initialCategory: AdCategory?
    private let onSelect: (AdCategory) -> Void

    private var selectedCategory: AdCategory?

    private let pickerView = UIPickerView()
    private let cancelButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let titleLabel = UILabel()

    init(
        selectedCategory: AdCategory?,
        onSelect: @escaping (AdCategory) -> Void
    ) {
        self.initialCategory = selectedCategory
        self.onSelect = onSelect

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        if let sheet = sheetPresentationController {
            if #available(iOS 16.0, *) {
                let compactDetent = UISheetPresentationController.Detent.custom(
                    identifier: UISheetPresentationController.Detent.Identifier("categoryPicker")
                ) { context in
                    min(CGFloat(350), context.maximumDetentValue)
                }

                sheet.detents = [compactDetent]
            } else {
                sheet.detents = [.medium()]
            }

            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 22
        }

        setupUI()
        selectInitialCategory()
    }

    private func setupUI() {
        titleLabel.text = "Категория"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center

        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(.secondaryLabel, for: .normal)
        cancelButton.addTarget(
            self,
            action: #selector(cancelTapped),
            for: .touchUpInside
        )

        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(AppColors.orange, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        doneButton.addTarget(
            self,
            action: #selector(doneTapped),
            for: .touchUpInside
        )

        pickerView.dataSource = self
        pickerView.delegate = self
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
        view.addSubview(pickerView)

        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(44)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cancelButton)
            make.centerX.equalToSuperview()
        }

        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(cancelButton)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        pickerView.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(216)
        }
    }

    private func selectInitialCategory() {
        let row = initialCategory
            .flatMap { categories.firstIndex(of: $0) }
            ?? 0

        pickerView.selectRow(row, inComponent: 0, animated: false)
        selectedCategory = categories[row]
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func doneTapped() {
        if let selectedCategory {
            onSelect(selectedCategory)
        }

        dismiss(animated: true)
    }
}

extension CategoryPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        categories.count
    }
}

extension CategoryPickerViewController: UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        categories[row].rawValue
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        selectedCategory = categories[row]
    }
}

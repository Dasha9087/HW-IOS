//
//  SecondViewController.swift
//  HW8
//
//  Created by Дарья on 16.05.2026.
//

import UIKit

class SecondViewController: UIViewController {
    
    let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        let houseLabel = UILabel()

        let lightsLabel = UILabel()
        let lightsSegmentedControl = UISegmentedControl(items: ["On", "Off"])

        let doorLabel = UILabel()
        let doorSegmentedControl = UISegmentedControl(items: ["Lock", "Unlock"])

        let acLabel = UILabel()
        let acSegmentedControl = UISegmentedControl(items: ["Auto", "On", "Off"])

        let temperatureLabel = UILabel()
        let temperatureSlider = UISlider()
        let temperatureValueLabel = UILabel()

        let alarmButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.brown.withAlphaComponent(0.7)

                setupUI()
            }

            func setupUI() {
                setupTitle()
                setupLights()
                setupDoor()
                setupAC()
                setupTemperature()
                setupAlarmButton()
            }

            func setupTitle() {
                titleLabel.text = "Welcome, user12314"
                titleLabel.textColor = .white
                titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(titleLabel)

                subtitleLabel.text = "Appartment control page"
                subtitleLabel.textColor = .white
                subtitleLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
                subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(subtitleLabel)

                houseLabel.text = "🏠"
                houseLabel.font = UIFont.systemFont(ofSize: 28)
                houseLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(houseLabel)

                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
                    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),

                    subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
                    subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),

                    houseLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5),
                    houseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35)
                ])
            }

            func setupLights() {
                lightsLabel.text = "Lights"
                lightsLabel.textColor = .white
                lightsLabel.font = UIFont.systemFont(ofSize: 20)
                lightsLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(lightsLabel)

                setupSegmentedControl(lightsSegmentedControl)
                lightsSegmentedControl.selectedSegmentIndex = 1

                lightsSegmentedControl.addTarget(
                    self,
                    action: #selector(lightsChanged),
                    for: .valueChanged
                )

                view.addSubview(lightsSegmentedControl)

                NSLayoutConstraint.activate([
                    lightsLabel.topAnchor.constraint(equalTo: houseLabel.bottomAnchor, constant: 55),
                    lightsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),

                    lightsSegmentedControl.topAnchor.constraint(equalTo: lightsLabel.bottomAnchor, constant: 15),
                    lightsSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
                    lightsSegmentedControl.widthAnchor.constraint(equalToConstant: 190),
                    lightsSegmentedControl.heightAnchor.constraint(equalToConstant: 35)
                ])
            }

            func setupDoor() {
                doorLabel.text = "Door"
                doorLabel.textColor = .white
                doorLabel.font = UIFont.systemFont(ofSize: 20)
                doorLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(doorLabel)

                setupSegmentedControl(doorSegmentedControl)
                doorSegmentedControl.selectedSegmentIndex = 1

                doorSegmentedControl.addTarget(
                    self,
                    action: #selector(doorChanged),
                    for: .valueChanged
                )

                view.addSubview(doorSegmentedControl)

                NSLayoutConstraint.activate([
                    doorLabel.topAnchor.constraint(equalTo: lightsSegmentedControl.bottomAnchor, constant: 45),
                    doorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),

                    doorSegmentedControl.topAnchor.constraint(equalTo: doorLabel.bottomAnchor, constant: 15),
                    doorSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
                    doorSegmentedControl.widthAnchor.constraint(equalToConstant: 190),
                    doorSegmentedControl.heightAnchor.constraint(equalToConstant: 35)
                ])
            }

            func setupAC() {
                acLabel.text = "A/C"
                acLabel.textColor = .white
                acLabel.font = UIFont.systemFont(ofSize: 20)
                acLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(acLabel)

                setupSegmentedControl(acSegmentedControl)
                acSegmentedControl.selectedSegmentIndex = 1

                acSegmentedControl.addTarget(
                    self,
                    action: #selector(acChanged),
                    for: .valueChanged
                )

                view.addSubview(acSegmentedControl)

                NSLayoutConstraint.activate([
                    acLabel.topAnchor.constraint(equalTo: doorSegmentedControl.bottomAnchor, constant: 45),
                    acLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),

                    acSegmentedControl.topAnchor.constraint(equalTo: acLabel.bottomAnchor, constant: 15),
                    acSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
                    acSegmentedControl.widthAnchor.constraint(equalToConstant: 230),
                    acSegmentedControl.heightAnchor.constraint(equalToConstant: 35)
                ])
            }

            func setupTemperature() {
                temperatureLabel.text = "Temperature"
                temperatureLabel.textColor = .white
                temperatureLabel.font = UIFont.systemFont(ofSize: 20)
                temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(temperatureLabel)

                temperatureSlider.minimumValue = 16
                temperatureSlider.maximumValue = 30
                temperatureSlider.value = 21
                temperatureSlider.translatesAutoresizingMaskIntoConstraints = false
                temperatureSlider.addTarget(
                    self,
                    action: #selector(temperatureChanged),
                    for: .valueChanged
                )
                view.addSubview(temperatureSlider)

                temperatureValueLabel.text = "21 °C"
                temperatureValueLabel.textColor = .white
                temperatureValueLabel.font = UIFont.systemFont(ofSize: 17)
                temperatureValueLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(temperatureValueLabel)

                NSLayoutConstraint.activate([
                    temperatureLabel.topAnchor.constraint(equalTo: acSegmentedControl.bottomAnchor, constant: 45),
                    temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),

                    temperatureSlider.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
                    temperatureSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
                    temperatureSlider.widthAnchor.constraint(equalToConstant: 170),

                    temperatureValueLabel.centerYAnchor.constraint(equalTo: temperatureSlider.centerYAnchor),
                    temperatureValueLabel.leadingAnchor.constraint(equalTo: temperatureSlider.trailingAnchor, constant: 25)
                ])
            }

            func setupAlarmButton() {
                alarmButton.setTitle("Alarm", for: .normal)
                alarmButton.setTitleColor(.red, for: .normal)
                alarmButton.backgroundColor = .white
                alarmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                alarmButton.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(alarmButton)

                alarmButton.addTarget(
                    self,
                    action: #selector(alarmButtonTapped),
                    for: .touchUpInside
                )

                NSLayoutConstraint.activate([
                    alarmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
                    alarmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                    alarmButton.widthAnchor.constraint(equalToConstant: 80),
                    alarmButton.heightAnchor.constraint(equalToConstant: 45)
                ])
            }

            func setupSegmentedControl(_ segmentedControl: UISegmentedControl) {
                segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                segmentedControl.selectedSegmentTintColor = .white

                segmentedControl.setTitleTextAttributes([
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 15)
                ], for: .normal)

                segmentedControl.setTitleTextAttributes([
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
                ], for: .selected)

                segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            }

            @objc func lightsChanged(_ sender: UISegmentedControl) {
                if sender.selectedSegmentIndex == 0 {
                    print("Lights On")
                } else {
                    print("Lights Off")
                }
            }

            @objc func doorChanged(_ sender: UISegmentedControl) {
                if sender.selectedSegmentIndex == 0 {
                    print("Door Lock")
                } else {
                    print("Door Unlock")
                }
            }

            @objc func acChanged(_ sender: UISegmentedControl) {
                if sender.selectedSegmentIndex == 0 {
                    print("A/C On")
                } else {
                    print("A/C Off")
                }
            }

            @objc func temperatureChanged(_ sender: UISlider) {
                let temperature = Int(sender.value)
                temperatureValueLabel.text = "\(temperature) °C"
            }

            @objc func alarmButtonTapped() {
                print("Alarm tapped")
            }
        }
    

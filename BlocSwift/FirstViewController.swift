//
//  FirstViewController.swift
//  BlocSwift
//
//  Created by PATRICK LESAINT on 23/04/2020.
//  Copyright © 2020 PATRICK LESAINT. All rights reserved.
//

import UIKit
import RxSwift

/* Declare as global */
let counterManager = CounterManager()

class FirstViewController: UIViewController {

    let bag = DisposeBag()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        counterManager.output.subscribe(onNext: { counter in
            self.label.text = "\(counter)"
        }).disposed(by: bag)
        
        counterManager.error.subscribe(onNext: { error in
            self.alertError(error: error)
        }).disposed(by: bag)
    }
    
    private func alertError(error: CounterError) {
        var message = ""
        
        switch error {
        case .counterIsNegative:
            message = "You reached the limit guys !!! Counter must be positive..."
            break
        case .counterIsGreaterThanTen:
            message = "You reached the limit guys !!! Counter must be smaller than 10..."
            break
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok man", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let incBtn = UIButton()
        view.addSubview(incBtn)
        
        incBtn.setTitle("Incrementer", for: .normal)
        incBtn.setTitleColor(.white, for: .normal)
        incBtn.backgroundColor = .purple
        incBtn.translatesAutoresizingMaskIntoConstraints = false
        incBtn.widthAnchor.constraint(equalToConstant: 110).isActive = true
        incBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        incBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        incBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 100).isActive = true
        incBtn.addTarget(self, action: #selector(onIncrementer), for: .touchUpInside)
        
        let decBtn = UIButton()
        view.addSubview(decBtn)
        
        decBtn.setTitle("Decrementer", for: .normal)
        decBtn.setTitleColor(.white, for: .normal)
        decBtn.backgroundColor = .purple
        decBtn.translatesAutoresizingMaskIntoConstraints = false
        decBtn.widthAnchor.constraint(equalToConstant: 110).isActive = true
        decBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        decBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        decBtn.topAnchor.constraint(equalTo: incBtn.bottomAnchor, constant: 40).isActive = true
        decBtn.addTarget(self, action: #selector(onDecrementer), for: .touchUpInside)
        
        let openBtn = UIButton()
        view.addSubview(openBtn)

        openBtn.setTitle("Open second page", for: .normal)
        openBtn.setTitleColor(.white, for: .normal)
        openBtn.backgroundColor = .purple
        openBtn.translatesAutoresizingMaskIntoConstraints = false
        openBtn.widthAnchor.constraint(equalToConstant: 170).isActive = true
        openBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        openBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openBtn.topAnchor.constraint(equalTo: decBtn.bottomAnchor, constant: 40).isActive = true
        openBtn.addTarget(self, action: #selector(onOpen), for: .touchUpInside)
    }

    @objc func onIncrementer() {
        counterManager.input.onNext(.IncrementEvent)
    }

    @objc func onDecrementer() {
        counterManager.input.onNext(.DecrementEvent)
    }
    
    @objc func onOpen() {
        let vc = SecondViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
    }
}

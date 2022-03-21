//
//  ViewController.swift
//  AssertionNotifier
//
//  Created by Elísio Freitas Fernandes on 10/05/2021.
//  Copyright (c) 2021 Elísio Fernandes
//  MIT license, see LICENSE file for details
//

import UIKit
import AssertionNotifier

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
        button.setTitle("Assert", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        self.view.addSubview(button)

        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func didTapButton(sender: UIButton) {

        AssertionNotifier.shared.assert(false,
                                        file: #file,
                                        line: #line)
    }
}


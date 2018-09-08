//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.//

import Foundation
import UIKit

import CircularProgress

final class CircularProgressViewSamplerViewController: UIViewController {

    @IBOutlet weak var progressViewPlaceholder: UIView!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var animateSwitch: UISwitch!
    @IBOutlet weak var continuousSwitch: UISwitch!
    @IBOutlet weak var progressSlider: UISlider!

    private lazy var progressView: CircularProgressView = self.lazyCircularProgressViews()

    private let strategy: CircularProgressViewStrategy

    init(strategy: CircularProgressViewStrategy) {
        self.strategy = strategy

        super.init(nibName: nil, bundle: nil)

        self.title = "Playground"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CircularProgressViewSamplerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        progressViewPlaceholder.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: progressViewPlaceholder.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: progressViewPlaceholder.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo: progressViewPlaceholder.centerXAnchor),
            progressView.widthAnchor.constraint(equalTo: progressViewPlaceholder.widthAnchor, multiplier: 0.5)
        ])
        
        userChangedColor(colorSegmentedControl)
        userChangedState(stateSegmentedControl)
    }
}

extension CircularProgressViewSamplerViewController {

    @IBAction
    private func userChangedProgressValue() {

        let doubleValue = Double(progressSlider.value)
        let percentComplete = FractionCompleted(doubleValue)

        if animateSwitch.isOn {
            progressView.state = .progress(percentComplete)
        } else {
            progressView.setState(.progress(percentComplete), animated: false)
        }

        stateSegmentedControl.selectedSegmentIndex = 1
    }

    @IBAction
    private func userChangedColor(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            progressView.tintColor = .blue
        case 1:
            progressView.tintColor = .green
        case 2:
            progressView.tintColor = .gray
        default:
            progressView.tintColor = .red
        }
    }

    @IBAction
    private func userChangedState(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            progressView.setState(.indeterminate, animated: animateSwitch.isOn)
        default:
            progressSlider.value = 0
            userChangedProgressValue()
        }
    }

    @IBAction
    private func userToggledContinuousProgressSwitch() {
        progressSlider.isContinuous = continuousSwitch.isOn
    }
}

extension CircularProgressViewSamplerViewController {

    private func lazyCircularProgressViews() -> CircularProgressView {
        return CircularProgressView(strategy: strategy)
    }
}

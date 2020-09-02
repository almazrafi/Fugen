//
//  ViewController.swift
//  FugenDemo
//
//  Created by Almaz Ibragimov on 16.11.2019.
//  Copyright © 2019 Almaz Ibragimov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var cardView: ShadowStyleView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorStyle.razzmatazz.color
        view.backgroundColor = UIColor(style: .razzmatazz)

        label.attributedText = TextStyle.title.attributedString("Hello world")
        label.attributedText = NSAttributedString(string: "Hello world", style: .title)

        label.attributedText = TextStyle
            .title
            .withColor(.white)
            .withLineBreakMode(.byWordWrapping)
            .attributedString("Hello world")

        imageView.image = Images.cloud

        cardView.shadowStyle = .cardShadow
        label.shadow = .thinShadow
    }
}

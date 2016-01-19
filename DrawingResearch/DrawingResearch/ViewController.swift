//
//  ViewController.swift
//  DrawingResearch
//
//  Created by Maxim Pervushin on 19/01/16.
//  Copyright © 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView1: DrawView!
    @IBOutlet weak var drawView2: DrawView!
    @IBOutlet weak var drawView3: DrawView!
    @IBOutlet weak var drawView4: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let visibleColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        let invisibleColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)

        drawView1.colors = [visibleColor, visibleColor/*, visibleColor, visibleColor*/, invisibleColor, invisibleColor]

//        drawView1.colors = [UIColor.orangeColor()]
        drawView2.colors = [UIColor.redColor(), UIColor.blueColor()]
        drawView3.colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor()]
        drawView4.colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


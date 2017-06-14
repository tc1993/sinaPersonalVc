//
//  pushViewcontroller.swift
//  sinaPersonalV
//
//  Created by 唐超 on 6/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation;
import UIKit;

class PushViewcontroller: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        self.title = "新控制器";
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
    }
}

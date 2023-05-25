//
//  HomeViewController.swift
//  hidenseek
//
//  Created by Jeremy Christopher on 25/05/23.
//

import Foundation
import UIKit
import SceneKit

class HomeViewController: UIViewController {
    
   
    @IBAction func clickstart(_ sender: Any) {
        print("clickstart")
        let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "mainview") as! GameViewController
        self.navigationController?.pushViewController(loginPageView, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}





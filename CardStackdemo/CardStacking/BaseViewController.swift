//
//  BaseViewController.swift
//  CardStacking
//
//  Created by Mr.Huang on 2017/7/4.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    public let fuzzyImgView = UIImageView.init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fuzzyImgView.frame = view.bounds
        fuzzyImgView.contentMode = .scaleAspectFill
        view.addSubview(fuzzyImgView)
        let effect = UIBlurEffect.init(style: .light)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = view.bounds
        fuzzyImgView.addSubview(effectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

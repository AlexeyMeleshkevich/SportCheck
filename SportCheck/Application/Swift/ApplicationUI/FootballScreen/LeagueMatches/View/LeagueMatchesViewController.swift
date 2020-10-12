//
//  LeagueMatchesViewController.swift
//  SportCheck
//
//  Created by Alexey Meleshkevich on 08.10.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class LeagueMatchesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCommonUI()
        setUI()
    }
    
    fileprivate func setupCommonUI() {
        title = "Matches"
        
        view.backgroundColor = UIColor.white
    }
    
    fileprivate func setUI() {
        
    }
}

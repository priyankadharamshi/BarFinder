//
//  TabBarController.swift
//  BarFinder
//
//  Created by Priyanka  on 08/06/18.
//  Copyright © 2018 Priyanka . All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nav1 = UINavigationController()
        let beerListTableViewController = BeerListTableViewController()
        nav1.viewControllers = [beerListTableViewController]
        nav1.tabBarItem = UITabBarItem(title: "List View", image: UIImage(named:"IconNav1"), tag: 0)
        
        let nav2 = UINavigationController()
        let mapViewController = MapViewController()
        
        nav2.viewControllers = [mapViewController]
        nav2.tabBarItem = UITabBarItem(title: "Map View", image: UIImage(named:"IconNav2"), tag: 1)
        self.viewControllers = [nav1, nav2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

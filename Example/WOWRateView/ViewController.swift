//
//  ViewController.swift
//  WOWRateView
//
//  Created by Zhou Hao on 12/06/2016.
//  Copyright (c) 2016 Zhou Hao. All rights reserved.
//

import UIKit
import WOWRateView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WOWRateViewDelegate {

    var titles = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.titles = ["Default",
                       "Frame :- Extra H(500),W(600) ignored",
                       "Responsive to Star Size",
                       "Customizable Border, Normal, Fill Color",
                       "UIColor MAGIC : colorWithPatternImage:",
                       "Fill Mode - Horizontal",
                       "Fill Mode - Vertical",
                       "Fill Mode - Axial",
                       "Change Star Count & add padding",
                       "CanRate - Try touch / tap / touch drag",
                       "-------END OF STORY-----"];
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateViewCell", for: indexPath) as! RateViewCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.rateView.starSize = (indexPath.row > 1) ? 50 : 30
        cell.rateView.rating = 3.4
        
        if indexPath.row == 0 {
            cell.rateView.rating = 3.6
        }
        else if indexPath.row == 1 {
            cell.rateView.rating = 4.4
        }
        else if indexPath.row == 2 {
            cell.rateView.rating = 3.3
        } else if indexPath.row == 3 {
            cell.rateView.rating = 4.3
            cell.rateView.starNormalColor = UIColor(red: CGFloat(255 / 255.0), green: CGFloat(255 / 255.0), blue: CGFloat(255 / 255.0), alpha: CGFloat(1.0))
            cell.rateView.starFillColor = UIColor(red: CGFloat(255 / 255.0), green: CGFloat(209 / 255.0), blue: CGFloat(23 / 255.0), alpha: CGFloat(1.0))
            cell.rateView.starBorderColor = UIColor(red: CGFloat(38 / 255.0), green: CGFloat(38 / 255.0), blue: CGFloat(38 / 255.0), alpha: CGFloat(1.0))
        } else if indexPath.row == 4 {
            cell.rateView.rating = 2.6
            cell.rateView.starNormalColor = UIColor(patternImage: UIImage(named: "image0.jpeg")!)
            cell.rateView.starFillColor = UIColor(patternImage: UIImage(named: "image1.jpeg")!)
            cell.rateView.starBorderColor = UIColor(patternImage: UIImage(named: "image2.jpeg")!)
        }
        // Modes - Horizontal, Vertical, Axial
        if indexPath.row == 6 {
            cell.rateView.rating = 2.35
            cell.rateView.starFillMode = .vertical
        }
        else if indexPath.row == 7 {
            cell.rateView.rating = 3.65
            cell.rateView.starFillMode = .axial
        }
        else if indexPath.row == 8 {
            cell.rateView.starCount = 4
            cell.rateView.padding = 10.0
            cell.rateView.rating = 3.5
        }
        else {
            cell.rateView.step = 0.5
            cell.rateView.starFillMode = .horizontal
        }
        
        cell.rateView.isCanRate = (indexPath.row == 9)
        cell.rateView.delegate = (indexPath.row == 9) ? self : nil
//        cell.rateView.isHidden = (indexPath.row == 9)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,animated: true)
    }
    
    func rateView(_ rateView: WOWRateView, didUpdateRating rating: Float) {
        print("rateViewDidUpdateRating: \(rating)")
    }
}


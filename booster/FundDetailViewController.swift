//
//  FundDetailViewController.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit
import Charts

class FundDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var investorType:InvestorType?
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var fundObject:FundObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTableView.register(UINib.init(nibName: "FundDetailCell", bundle: nil), forCellReuseIdentifier: "FundDetailCell")
        self.mainTableView.rowHeight = UITableViewAutomaticDimension
        self.mainTableView.estimatedRowHeight = 140
        // Do any additional setup after loading the view, typically from a nib.
        if investorType != nil
        {
            self.loadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData()
    {
        //Load plist
        var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
        
        var plistData:Array<AnyObject>?  //our data
        let plistPath:String? = Bundle.main.path(forResource: "AvailableFunds", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)! //the data in XML format
        do{ //convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML,options: .mutableContainersAndLeaves,format: &format) as? Array<AnyObject>
            
            var selectedFund = 0
            switch self.investorType! {
            case .Defensive:
                selectedFund = 0
                break
            case .Conservative:
                selectedFund = 1
                break
            case .Balanced:
                selectedFund = 2
                break
            case .BalancedGrowth:
                selectedFund = 3
                break
            case .Growth:
                selectedFund = 4
                break
            case .AggressiveGrowth:
                selectedFund = 5
                break
            }
            
            if let selectedFund:[String:AnyObject] = plistData?[selectedFund] as? [String:AnyObject]
            {
                self.fundObject = FundObject(plist: selectedFund)
                self.title = self.fundObject?.title
                if let assets:FundAssets = self.fundObject?.assets
                {
                    //Load pie Charts
                    var chartEntries:Array<PieChartDataEntry> = []
                    var colors:Array<UIColor> = []
                    for incomeEntry in assets.income!
                    {
                        let pieEntry:PieChartDataEntry = PieChartDataEntry(value: incomeEntry.value!, label: incomeEntry.title, data: "income" as AnyObject?)
                        chartEntries.append(pieEntry)
                        let alpha:Double = incomeEntry.value! / 100
                        print(alpha)
                        colors.append(DefaultTheme.Color(color: .secondaryColorDark).lighter(amount: CGFloat(alpha)))
                    }
                    
                    for growthEntry in assets.growth!
                    {
                        let pieEntry:PieChartDataEntry = PieChartDataEntry(value: growthEntry.value!, label: growthEntry.title, data: "growth" as AnyObject?)
                        chartEntries.append(pieEntry)
                        let alpha:Double = growthEntry.value! / 100
                        print(alpha)
                        colors.append(DefaultTheme.Color(color: .primaryColorDark).lighter(amount: CGFloat(alpha)))
                    }
                    
                    let chartDataset:PieChartDataSet = PieChartDataSet(values: chartEntries, label: "")
                    chartDataset.setColors(colors, alpha: 1.0)
                    let chartData:PieChartData = PieChartData(dataSet: chartDataset)
                    chartData.setValueTextColor(UIColor.black)
                    self.pieChartView.data = chartData
                    //Piechart customization
                    self.pieChartView.chartDescription?.text = nil
                    self.pieChartView.noDataTextColor = DefaultTheme.Color(color: .primaryColorDark)
                    //Legend customization
                    let legend = self.pieChartView.legend
                    legend.textColor = UIColor.black
                    legend.position = .belowChartCenter
                    
                    self.pieChartView.entryLabelColor = DefaultTheme.Color(color: .primaryColorDark)
                    self.pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeInOutBack)
                }
                self.mainTableView.reloadData()
            }
            
        }
        catch{ // error condition
            print("Error reading plist: \(error), format: \(format)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.fundObject == nil
        {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let infoCount = self.fundObject?.info?.count
        {
            return infoCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fundCell:FundDetailCell = tableView.dequeueReusableCell(withIdentifier: "FundDetailCell", for: indexPath) as! FundDetailCell
        fundCell.customImageView?.image = UIImage(icon: .FACircle, size: CGSize(width: 10.0, height: 10.0))
        fundCell.customTextLabel.text = self.fundObject?.info?[indexPath.row]
        return fundCell
    }
    
    
}

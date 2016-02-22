//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    var filteredBus = [Business]()
    let searchController = UISearchController(searchResultsController: nil)
    var businesses: [Business]!
    var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    @IBOutlet weak var tableView: UITableView!
    
    var SearchResults:Array<Business>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search"
        var leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        if self.businesses == nil {
            self.SearchResults = nil
            return
        }
        self.SearchResults = self.businesses!.filter({( aSpecies: Business) -> Bool in
            // to start, let's just search by name
            return aSpecies.name!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }
        else {
            return 0;
        }
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.SearchResults?.count ?? 0
        } else {
            return self.businesses?.count ?? 0
        }
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        /*let bus: Business
        if searchController.active && searchController.searchBar.text != "" {
            bus = filteredBus[indexPath.row]
        } else {
            bus = businesses[indexPath.row]
        }
        cell.textLabel?.text = bus.name
        cell.detailTextLabel?.text = bus.categories*/
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController:FiltersViewController, didUpdateFilters filters: [String:AnyObject]) {
        
        var categories = filters["categories"] as? [String]
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {
            (businesses:[Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }


}

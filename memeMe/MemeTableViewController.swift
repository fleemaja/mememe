//
//  MemeTableViewController.swift
//  memeMe
//
//  Created by Drew Fleeman on 6/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }


    // MARK: - UITableView data source methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        
        if let memeCell = cell as? MemeTableViewCell {
            memeCell.meme = meme
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let cell = sender as? MemeTableViewCell,
               let indexPath = tableView.indexPath(for: cell),
               let dvc = segue.destination as? DetailViewController {
                   dvc.meme = self.memes[indexPath.row]
            }
        }
    }
    
}

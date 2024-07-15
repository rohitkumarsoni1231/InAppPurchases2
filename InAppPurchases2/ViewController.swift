//
//  ViewController.swift
//  IAPConsumable
//
//  Created by Rohit Kumar on 12/07/2024.
//

import UIKit

struct Model {
    var title: String
    var handler : (()-> Void)
}

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var myGemCounts: Int {
        return UserDefaults.standard.integer(forKey: "diamond_count")
    }
    
    func setupHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        let imageView = UIImageView(image: UIImage(systemName: "suit.diamond.fill"))
        let gemLabel = UILabel(frame: CGRect(x: 10, y: 120, width: view.frame.size.width - 20, height: 100))
        imageView.frame = CGRect(x: (view.frame.size.width - 100)/2, y: 20, width: 100, height: 100)
        imageView.tintColor = .systemBlue
        header.backgroundColor = .systemGreen
        header.addSubview(imageView)
        header.addSubview(gemLabel)
        view.addSubview(header)
        gemLabel.text = "Diamonds: \(myGemCounts)"
        gemLabel.textAlignment = .center
        gemLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        tableView.tableHeaderView = header
    }

    var models = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        models.append(Model(title: "500", handler: {
            IAPManager.shared.purchase(product: .gem_500) { [weak self] count in
               DispatchQueue.main.async {
                   let currentCount = self?.myGemCounts ?? 0
                   let newCount = currentCount + count
                   UserDefaults.standard.setValue(newCount, forKey: "diamond_count")
                   self?.setupHeader()
               }
            }
        }))
        
        models.append(Model(title: "1000", handler: {
            IAPManager.shared.purchase(product: .gem_1000) { [weak self] count in
                DispatchQueue.main.async {
                    let currentCount = self?.myGemCounts ?? 0
                    let newCount = currentCount + count
                    UserDefaults.standard.setValue(newCount, forKey: "diamond_count")
                    self?.setupHeader()
                }
            }
        }))
        
        models.append(Model(title: "2500", handler: {
            IAPManager.shared.purchase(product: .gem_2500) { [weak self] count in
                DispatchQueue.main.async {
                    let currentCount = self?.myGemCounts ?? 0
                    let newCount = currentCount + count
                    UserDefaults.standard.setValue(newCount, forKey: "diamond_count")
                    self?.setupHeader()
                }
            }
        }))
        
        models.append(Model(title: "5000", handler: {
            IAPManager.shared.purchase(product: .gem_5000) { [weak self] count in
                DispatchQueue.main.async {
                    let currentCount = self?.myGemCounts ?? 0
                    let newCount = currentCount + count
                    UserDefaults.standard.setValue(newCount, forKey: "diamond_count")
                    self?.setupHeader()
                }
            }
        }))
            
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        setupHeader()
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = model.title
        cell.imageView?.image = UIImage(systemName: "suit.diamond.fill")
        cell.imageView?.tintColor = .systemBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,animated: true)
        //Show Purchase
        
        let model = models[indexPath.row]
        model.handler()
    }
    
}

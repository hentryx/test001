//
//  MapViewController.swift
//  test001
//
//  Created by Henry Bautista on 23/05/18.
//  Copyright © 2018 Henry Bautista. All rights reserved.
//

import UIKit

struct SchoolBuses: Decodable {
    let response: Bool?
    let school_buses: [SchoolBus]?
}

struct SchoolBus: Decodable {
    let description: String?
    let id: Int?
    let img_url: String?
    let name: String?
    let stops_url: String?
}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var buses = [SchoolBus]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        super.viewDidLoad()
        
        guard let url = URL(string: "https://api.myjson.com/bins/10yg1t") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else{
                guard let data = data else { return }
                // let dataAsString = String(data:data, encoding: .utf8)
                // print(dataAsString as Any)
                do {
                    let schoolBuses = try JSONDecoder().decode(SchoolBuses.self, from: data)
                //    print(schoolBuses.response as Any)
                //    print(schoolBuses.school_buses as Any)
                    self.buses = schoolBuses.school_buses!;
                //    print(self.buses[0].name as Any)
                } catch let jsonErr {
                    print("Error Serializando Json", jsonErr)
                }
                DispatchQueue.main.async {
                    print(self.buses.count)
                    self.collectionView.reloadData()
                }
            }
        }.resume()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.buses.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.labelCell.text = self.buses[indexPath.row].name!
        cell.ImageCell.contentMode = .scaleAspectFill
        cell.ImageCell.downloadedFrom(link: self.buses[indexPath.row].img_url!)
        
        return cell
        
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailView.id = self.buses[indexPath.row].id!
        detailView.name = self.buses[indexPath.row].name!
        detailView.descrip = self.buses[indexPath.row].description!
        detailView.imageUrl = self.buses[indexPath.row].img_url!
        detailView.stopsUrl = self.buses[indexPath.row].stops_url!
        self.present(detailView, animated: true, completion: nil)
    }
    


}

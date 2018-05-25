//
//  DetailViewController.swift
//  test001
//
//  Created by Henry Bautista on 24/05/18.
//  Copyright © 2018 Henry Bautista. All rights reserved.
//

import UIKit
import MapKit

// Estructuras para parsear los JSON
struct Stops: Decodable {
    let response: Bool?
    let stops: [Stop]?
}

struct Stop: Decodable {
    let lat: Double?
    let lng: Double?
}

class DetailViewController: UIViewController , MKMapViewDelegate {
    
    var id = -1
    var stopsUrl = ""
    var name = ""
    var imageUrl = ""
    var descrip = ""
    var stops = [Stop]()
    
    // Esructura adicional para el frmato mapkit, auxilia la inclucion de los pines
    class Station: NSObject, MKAnnotation {
        var title: String?
        var subtitle: String?
        var latitude: Double
        var longitude:Double
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    // accion para el boton volver. recuperacion de memoria
    @IBAction func backButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let routesView = storyBoard.instantiateViewController(withIdentifier: "theSecondView") as! MapViewController
        self.present(routesView, animated: true, completion: nil)
    }

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        nameLabel.text = self.name
        descLabel.text = self.descrip
        // aqui inicia la obtencion de la data
        guard let url = URL(string: self.stopsUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else{
                guard let data = data else { return }
                 let dataAsString = String(data:data, encoding: .utf8)
                 print(dataAsString as Any)
                do {
                    let points = try JSONDecoder().decode(Stops.self, from: data)
                    // print(points.stops! as Any)
                    self.stops = points.stops!
                } catch let jsonErr {
                    print("Error Serializando Json", jsonErr)
                }
                DispatchQueue.main.async {
                    // se asegura de haber recuperado los datos para luego si dibujar
                    self.zoomToRegion(lat: self.stops[Int(round(Double(self.stops.count/2)))].lat!,lng:self.stops[0].lng!
                    )
                    var annotations:Array = [Station]()
                    for item in self.stops {
                        let annotation = Station(latitude: item.lat!, longitude: item.lng!)
                        annotation.title = String(format:"%f",item.lat!) + ", " + String(format:"%f",item.lng!)
                        annotations.append(annotation)
                    }
                    // añade los pines
                    self.mapView.addAnnotations(annotations)
                    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
                    for annotation in annotations {
                        points.append(annotation.coordinate)
                    }
                    let polyline = MKPolyline(coordinates: points, count: points.count)
                    // añade la ruta azul
                    self.mapView.add(polyline)
                    self.mapView.showsCompass = true
                }
            }
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // funcion para acercar medianamente la region a graficar
    func zoomToRegion(lat:Double,lng:Double) {
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegionMakeWithDistance(location, 800.0, 2500.0)
        mapView.setRegion(region, animated: true)
    }
    
    // funcion para renderizar la ruta azul
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            
        }
        return polylineRenderer
    }
}

//
//  MainViewController.swift
//  PointOfInterest
//
//  Created by David Linhares on 28/11/2018.
//  Copyright © 2018 David Linhares. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    private var pois: [PointOfInterest] = []
    private var annotations: [MKPointAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.mapView.delegate = self
        self.fetchData()
    }

    func fetchData() {
        Alamofire.request(ApiManager.api_url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    guard let json = data as? [[String: Any]] else {
                        return
                    }
                    self.pois.append(contentsOf: json.compactMap({
                        guard let poi = PointOfInterest.from(json: $0) else {
                            return nil
                        }
                        let annotation = self.pointAnnotation(from: poi)
                        self.annotations.append(annotation)
                        self.mapView.addAnnotation(annotation)

                        return poi
                    }))
                    self.tableView.reloadData()
                case .failure(_):
                    return
                }
        }
    }

    private func pointAnnotation(from pointOfInterest: PointOfInterest) -> MKPointAnnotation {
        let point = MKPointAnnotation()
        point.title = pointOfInterest.title
        point.subtitle = pointOfInterest.details
        point.coordinate.latitude = pointOfInterest.coordinates.0
        point.coordinate.longitude = pointOfInterest.coordinates.1

        return point
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let point = annotations[indexPath.row]
        self.mapView.setRegion(MKCoordinateRegion(center: point.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pois.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = pois[indexPath.row].title

        return cell
    }
}

extension MainViewController: MKMapViewDelegate {
}

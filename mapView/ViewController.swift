//
//  ViewController.swift
//  mapView
//
//  Created by 河邊安澄 on 2020/03/28.
//  Copyright © 2020 Azumi.Kawabe. All rights reserved.
//

import UIKit
import MapKit
import Social

class ViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var labelAltitude: UILabel!
    

    @IBAction func tapFacebook(_ sender: Any) {
        let facebookPostView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        facebookPostView.setInitialText("ここの標高は" + labelAltitude.text! + "です")
        self.present(facebookPostView, animated: true, completion: nil)
    }
    
    
    @IBAction func tapTwitter(_ sender: Any) {
        let twitterPostView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        twitterPostView.setInitialText("ここの標高は" + labelAltitude.text! + "でーす")
        self.present(twitterPostView, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //保存した座標を読み込む
        //UserDefaultsを生成
        let ud = UserDefaults.standard
        
        //緯経度を読み込む
        let lat = ud.double(forKey: "LAT")
        let lon = ud.double(forKey: "LON")
        
        //CLLocationCoordinate2Dに変換
        let coordinate = CLLocationCoordinate2DMake(lat,lon)
        
        //表示範囲を読み込む
        let latDelta:CLLocationDegrees = ud.double(forKey: "LAT_DELTA")
        let lonDelta:CLLocationDegrees = ud.double(forKey: "LON_DELTA")
        
        //MKCoorDinateSpanに変換
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta);
        
        //表示範囲と緯度経度を地図に設定する
        mapView.region.span = span
        mapView.setCenter(coordinate, animated: false)
        mapView.delegate = self
    }
    
    //スクロールのデリゲートファンクション　緯経度を保存する
    func mapView(_ mapView: MKMapView,regionDidChangeAnimated animated: Bool) {
        //UserDefaults 生成
        let ud = UserDefaults.standard
        
        //緯経度を保存する
        ud.set(mapView.centerCoordinate.latitude, forKey: "LAT")
        ud.set(mapView.centerCoordinate.longitude, forKey: "LON")
        
        //表示範囲を保存する
        ud.set(mapView.region.span.latitudeDelta, forKey: "LAT_DELTA")
        ud.set(mapView.region.span.longitudeDelta, forKey: "LON_DELTA")

        ud.synchronize()
        
        //緯度経度を渡して標高を取得する
        let altitude:Double = GisHelper.getAltitudeCoordinate(mapView.centerCoordinate)
        if(altitude != GisHelper.INVALID_ALT){
            labelAltitude.text = String(format: "%.1fm",altitude)
        }
        else{
            labelAltitude.text = ""
        }
    }


}


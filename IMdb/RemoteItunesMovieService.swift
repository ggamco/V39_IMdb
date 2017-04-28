//
//  RemoteItunesMovieService.swift
//  IMdb
//
//  Created by cice on 28/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RemoteItunesMovieService {
    
    //metodo top movies
    func getTopMovies(_ complitionHandler: @escaping([[String:String]]?) -> ()) {
        
        let urlData = CONSTANTES.URLS.BASE_URL
        Alamofire.request(URL(string: urlData)!, method: .get).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                if let valorData = responseData.result.value {
                    let json = JSON(valorData)
                    var resultData = [[String:String]]()
                    let entries = json["feed"]["entry"].arrayValue
                    
                    for c_entry in entries {
                        
                        var movieDiccionario = [String:String]()
                        movieDiccionario["id"] = c_entry["id"]["attributes"]["im:id"].stringValue
                        movieDiccionario[]
                        
                    }
                    
                    complitionHandler(resultData)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                complitionHandler(nil)
            }
            
        }
        
        
        
        
    }
}

//
//  API_UTILS.swift
//  IMdb
//
//  Created by cice on 28/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import Foundation
import UIKit

let CONSTANTES = Constantes()

struct Constantes {
    let COLORES = Colores()
    let URLS = Urls()
    let METODOS = Metodos()
}

struct Colores {
    let COLOR_GRIS_NAVTABBAR = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    let COLOR_ROJO_GENERAL = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
}

struct Urls {
    let BASE_URL = "https://itunes.apple.com/"
}

struct Metodos {
    let METODO_TOP = "es/rss/topmovies/limit=99/json"
    let METODO_SEARCH = "search"
}

//
//  LocalCoreDateService.swift
//  IMdb
//
//  Created by cice on 5/5/17.
//  Copyright © 2017 cice. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreDataService {
    
    let remoteMovieService = RemoteItunesMovieService()
    let stack = CoreDataStack.shared
    
    func searchMovie(by term: String, remoteHandler: @escaping([MovieModel]?) -> ()) {
        
        remoteMovieService.searchMovies(by: term) { (result) in
            if let movieData = result {
                
                var modelMovie = [MovieModel]()
                
                for c_movie in movieData {
                    let obj = MovieModel(pId: c_movie["id"]!,
                                         pTitle: c_movie["title"]!,
                                         pOrder: nil,
                                         pSummary: c_movie["summary"]!,
                                         pImage: c_movie["image"],
                                         pCategory: c_movie["category"]!,
                                         pDirector: c_movie["director"]!)
                    modelMovie.append(obj)
                }
                
                remoteHandler(modelMovie)
            } else {
                print("Error mientras se llama a los servicios de iTunes")
                remoteHandler(nil)
            }
        }
        
    }
    
    func topMovie(_ localHandler: @escaping([MovieModel]?) -> (), remoteHandler: @escaping([MovieModel]?) -> ()) {
        
        localHandler(queryTopMovies())
        
        remoteMovieService.getTopMovies { (result) in
            if let movieData = result {
                
                self.markAllMoviesAnsync()
                var order = 1
                
                for c_movieDiccionario in movieData {
                    
                    if let movieDataDes = self.getMovieById(c_movieDiccionario["id"]!, favorito: false) {
                        //actualizacion (UPDATE)
                        self.updateMovie(c_movieDiccionario, movie: movieDataDes, order: order)
                    } else {
                        //insertado (INSERT)
                        self.insertMovie(c_movieDiccionario, order: order)
                    }
                    
                    order += 1
                    
                }
                
                remoteHandler(self.queryTopMovies())
                
            } else {
                print("Error mientras se llama a la API de iTunes")
                remoteHandler(nil)
            }
        }
        
    }
    
    
    func queryTopMovies() -> [MovieModel]? {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "order", ascending: true)
        
        request.sortDescriptors = [sortDescription]
        
        let customPredicate = NSPredicate(format: "format = \(false)")
        request.predicate = customPredicate
        
        do{
            let fetchMovies = try context.fetch(request)
            var movies = [MovieModel]()
            
            for c_movie in fetchMovies {
                movies.append(c_movie.mappedObj())
            }
            
            return movies
        }catch{
            print("Error mientras se obtenian las peliculas desde CoreData")
            return nil
        }
        
        
        
    }
    
    
    func markAllMoviesAnsync() {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        
        do {
            
            let fetchMovies = try context.fetch(request)
            
            for c_manage in fetchMovies {
                c_manage.sync = false
            }
            
            try context.save()
            
        } catch {
            print("Error mientras se actualizan las peliculas desde CoreData")
        }
        
    }
    
    
    func getMovieById(_ id: String, favorito: Bool) -> MovieManager?{
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "id = \(id) AND favorito = \(favorito)")
        request.predicate = customPredicate
        
        do {
            
            let fetchMovies = try context.fetch(request)
            
            if fetchMovies.count > 0 {
                return fetchMovies.last
            } else {
                return nil
            }
            
        } catch {
            print("Error mientras se optienen las peliculas desde CoreData")
            return nil
        }
        
        
        
    }
    
    func insertMovie(_ movieDiccionario: [String : String], order: Int) {
        let context = stack.persistentContainer.viewContext
        let movie = MovieManager(context: context)
        
        movie.id = movieDiccionario["id"]
        updateMovie(movieDiccionario, movie: movie, order: order)
    }
    
    
    func updateMovie(_ movieDiccionario: [String : String], movie : MovieManager, order: Int) {
        
        let context = stack.persistentContainer.viewContext
        movie.order = Int16(order)
        movie.title = movieDiccionario["title"]
        movie.summary = movieDiccionario["summary"]
        movie.category = movieDiccionario["category"]
        movie.director = movieDiccionario["director"]
        movie.image = movieDiccionario["image"]
        movie.sync = true
        
        do {
            try context.save()
        } catch {
            print("Error mientras se actualiza el CoreData")
        }
        
    }
    
    
    
    
    
    
    
}

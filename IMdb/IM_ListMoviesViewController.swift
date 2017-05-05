//
//  IM_ListMoviesViewController.swift
//  IMdb
//
//  Created by cice on 5/5/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import Kingfisher

class IM_ListMoviesViewController: UIViewController {

    //MARK: - Variables locales
    var movies = [MovieModel]()
    var collectionPadding : CGFloat = 0
    
    let customRefresh = UIRefreshControl()
    let dataProvider = LocalCoreDataService()
    
    var tapGR : UITapGestureRecognizer!
    
    //MARK: - IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mySerarchBar: UISearchBar!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remote = RemoteItunesMovieService()
        
        remote.getTopMovies { (resultData) in
            print("\(resultData!)")
        }
        
        customRefresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        myCollectionView.refreshControl?.tintColor = UIColor.white
        myCollectionView.refreshControl = customRefresh
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySerarchBar.delegate = self
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        loadData()
        
        setupPadding()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Utils
    
    func loadData() {
        dataProvider.topMovie({ (localResult) in
            if let movieData = localResult {
                self.movies = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            } else {
                print("No hay registros en CoreData")
            }
        }) { (remoteResult) in
            if let movieData = remoteResult {
                self.movies = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                    self.customRefresh.endRefreshing()
                }
            }
        }
    }
    
    func hideKeyboard() {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}//FIN DE LA CLASE

extension IM_ListMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    func setupPadding() {
        let anchoPantalla = self.view.frame.width
        collectionPadding = (anchoPantalla - (3 * 113)) / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionPadding, left: collectionPadding, bottom: collectionPadding, right: collectionPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionPadding
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IM_DetailCustomCell
        
        let model = movies[indexPath.row]
        configuredCell(cell, withMovie: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }
    
    func configuredCell(_ cell: IM_DetailCustomCell, withMovie movie: MovieModel) {
        
        if let imageData = movie.image{
            //aqui el outlet de la celda
            
            cell.myImageMovie.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!),
                                          placeholder: #imageLiteral(resourceName: "img-loading"),
                                          options: nil,
                                          progressBlock: nil,
                                          completionHandler: nil)
        }
        
    }
    
    
    
    
    
    
    
}














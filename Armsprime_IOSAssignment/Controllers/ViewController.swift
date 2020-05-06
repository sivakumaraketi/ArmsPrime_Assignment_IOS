//
//  ViewController.swift
//  Armsprime_IOSAssignment
//
//  Created by Siva Kumar Aketi on 29/01/20.
//  Copyright © 2020 SivaKumarAketi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var myActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var noLabel: UILabel!
    
    @IBOutlet weak var myDropDown: DropDown!
    
    var newImageView:UIImageView?
    let persistence = PersistenceService.shared
    let store = DataStore.shared
    private var selectedLanguage = "en"
    private var pageCount = 1
    
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var recordsArray:[Int] = Array()
    var limit = 10
    let totalEnteries = 100
    var articles = [News]()
    //private var articles:[Article] = []
    
    var loadingData = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.newsTableView.isHidden = true
        newsTableView.estimatedRowHeight = 44
        newsTableView.rowHeight = UITableView.automaticDimension
        self.newsTableView.tableFooterView?.isHidden = true
        newsTableView.tableFooterView = UIView(frame: .zero)
        myDropDown.isHidden = true
        self.newsTableView.isHidden = true
        
        if NetworkConnectivity.isConnectedToInternet {
            noLabel.isHidden = true
            selectLanguage()
            
        } else {
            checkData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    func checkData() {
        
        DispatchQueue.main.async {
            self.noLabel.isHidden = false
            self.myDropDown.isHidden = true
            self.store.requestUsers(lanugage: self.selectedLanguage, pageCount: self.pageCount) { [weak self] (users) in
                
                
                if self?.pageCount == 0 {
                    self?.articles = users
                    
                } else {
                    //  self?.persistence.deleteRecords()
                    self?.articles.append(contentsOf: users)
                }
                
                DispatchQueue.main.async {
                    self?.loadingData = false
                    self?.newsTableView.isHidden = false
                    //self?.myActivity.stopAnimating()
                    self?.spinner.stopAnimating()
                    self?.newsTableView.reloadData()
                }
                if users.count == 0 {
                    self?.noLabel.text = noOfflineData
                }
            }
            // self.alertMessageOK(for: noInternetMessage)
        }
    }
    //this function is responsible for handling the drop down data
    func selectLanguage() {
        myDropDown.isHidden = false
        // The list of array to display. Can be changed dynamically
        myDropDown.optionArray = ["ar", "de", "en", "es", "fr", "he", "it", "nl", "no", "pt", "ru", "se", "ud", "zh"]
        // The the Closure returns Selected Index and String
        myDropDown.didSelect{(selectedText , index ,id) in
            if NetworkConnectivity.isConnectedToInternet {
                self.selectedLanguage = selectedText
                self.newsTableView.isHidden = true
                self.myDropDown.isHidden = true
                self.persistence.deleteRecords()
                self.myActivity.startAnimating()
                self.loadingData = false
                DispatchQueue.main.async {
                    self.store.requestUsers(lanugage: selectedText, pageCount: self.pageCount) { [weak self] (users) in
                        self?.articles = users
                        DispatchQueue.main.async {
                            self?.myDropDown.isHidden = false
                            self?.newsTableView.isHidden = false
                            self?.myActivity.stopAnimating()
                            self?.newsTableView.reloadData()
                            //self?.persistence.deleteRecords()
                        }
                    }
                }
            } else {
                self.checkData()
            }
        }
        
    }
    
}

extension ViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("index:\(indexPath.row)...\(pageCount)")
        if NetworkConnectivity.isConnectedToInternet {
            noLabel.isHidden = true
            if indexPath.row == 0 && pageCount > 1 {
                self.pageCount = 1
                DispatchQueue.main.async {
                    self.store.requestUsers(lanugage: self.selectedLanguage, pageCount: self.pageCount) { [weak self] (users) in
                        self?.articles = users
                        DispatchQueue.main.async {
                            self?.myDropDown.isHidden = false
                            self?.newsTableView.isHidden = false
                            self?.myActivity.stopAnimating()
                            self?.newsTableView.reloadData()
                            //self?.persistence.deleteRecords()
                        }
                    }
                }
            } else if indexPath.row == articles.count - 1 {
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: newsTableView.bounds.width, height: CGFloat(44))
                self.newsTableView.tableFooterView = spinner
                self.newsTableView.tableFooterView?.isHidden = false
                self.pageCount = pageCount + 1
                DispatchQueue.main.async {
                    self.store.requestUsers(lanugage: self.selectedLanguage, pageCount: self.pageCount) { [weak self] (users) in
                        self?.articles = users
                        
                        DispatchQueue.main.async {
                            self?.myDropDown.isHidden = false
                            self?.newsTableView.isHidden = false
                            self?.myActivity.stopAnimating()
                            self?.newsTableView.reloadData()
                            //self?.persistence.deleteRecords()
                        }
                    }
                }
            }
            
        } else {
            spinner.stopAnimating()
            // checkData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles.count >= 99 {
            spinner.stopAnimating()
        }
        return self.articles.count > 100 ? 100 : self.articles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as! NewsFeedTableViewCell
        cell.activityIndicator.stopAnimating()
        let user = articles[indexPath.row]
        cell.newsauthor.text = user.author ?? "NA"
        cell.newsTitle.text = user.title ?? "No Title"
        cell.newsPublishedAt.text = user.publishedAt ?? "NA"
        
        cell.newsDescription.text = user.desc ?? "No Desc"
        //for tapping description for more details
        let tapGesture1 = UITapGestureRecognizer (target: self, action: #selector(labelTap(tapGesture:)))
        cell.newsDescription.addGestureRecognizer(tapGesture1)
        cell.newsDescription.isUserInteractionEnabled = true
        
        let urlimage = user.urlimage
        if urlimage != nil{
            do {
                cell.newsImage.image = UIImage(data: urlimage as! Data)
            } catch {
                //print(error)
                cell.newsImage.image = UIImage(named: "noImage.png")
            }
            
            //for tapping image in a new window
            let tapGesture = UITapGestureRecognizer (target: self, action: #selector(imgTap(tapGesture:)))
            cell.newsImage.addGestureRecognizer(tapGesture)
            cell.newsImage.isUserInteractionEnabled = true
            
        }
        return cell
        
    }
    //after tapping description handling
    @objc func labelTap(tapGesture: UITapGestureRecognizer) {
        let labelView = tapGesture.view as! UILabel
        if labelView.numberOfLines == 0 {
            labelView.numberOfLines = 2
        } else {
            labelView.numberOfLines = 0
        }
        newsTableView.reloadData()
        print(labelView.constraints)
        
    }
    
    //for rotating image
    func rotateImage(image:UIImage) -> UIImage
    {
        var rotatedImage = UIImage()
        switch image.imageOrientation
        {
        case .right:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
            
        case .down:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .left)
            
        case .left:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
            
        default:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        }
        
        return rotatedImage
    }
    
    //after image tapping handling
    @objc func imgTap(tapGesture: UITapGestureRecognizer) {
        let imageView = tapGesture.view as! UIImageView
        let idToMove = imageView.tag
        //Do further execution where you need idToMove
        let imag = rotateImage(image: imageView.image!)
        newImageView = UIImageView(image: imag)
        //let lettest = imag
        newImageView?.frame = UIScreen.main.bounds
        if #available(iOS 13.0, *) {
            newImageView?.showsLargeContentViewer = true
            
        } 
        newImageView?.backgroundColor = .black
        newImageView?.contentMode = .scaleToFill
        newImageView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView?.addGestureRecognizer(tap)
        self.view.addSubview(newImageView!)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
}

//
//  DataSource.swift
//  Armsprime_IOSAssignment
//
//  Created by Amsys on 02/02/20.
//  Copyright © 2020 SivaKumarAketi. All rights reserved.
//

import UIKit
import CoreData
// this class is responsible for getting api response and storing into coredata
class DataStore: NSObject {
    
    let persistence = PersistenceService.shared
    let networking = APIClient.shared
    
    var totalResults = 0
    private override init() {
        super.init()
    }
    static let shared = DataStore()
    
    /// Returns nil if image data is not correct or some network error has happened
    func getImageFromUrl(sourceUrl: String) -> UIImage? {
      if let url = URL(string: sourceUrl) {
        if let imageData = try? Data(contentsOf:url) {
          return UIImage(data: imageData)
        }
      }
      return nil
    }
    
    func requestUsers(lanugage:String,pageCount:Int,completion: @escaping([News]) -> Void){
        //go out to the internet
        
                        APIClient.newsPaper(language: lanugage, page: pageCount) { [weak self]  response in
                            switch response?.result {
                            case .success:
                                if let newsData = response?.result.value as? [String:AnyObject] {
                                  // self?.persistence.deleteRecords()
                                    if let myTotalResults = newsData["totalResults"] as? Int {
                                     self?.totalResults = myTotalResults
                                    }
                                    if let articlesFromJson = newsData["articles"] as? [[String : AnyObject]] {
                                        for articlesFromJson in articlesFromJson {
                                           // let article = Article()
                                            if let strongSelf = self,let author = articlesFromJson["author"] as? AnyObject,let title = articlesFromJson["title"] as? String, let desc = articlesFromJson["description"] as? String, let publishedAt = articlesFromJson["publishedAt"] as? String, let urlimage = articlesFromJson["urlToImage"] as? String{
                                             
                                              let article = News(context: strongSelf.persistence.context)
                                             
                                             if article.author != "<null>"{
                                                 article.author = author as? String
                                             }
                                             article.title = title
                                             article.desc = desc
                                             article.publishedAt = publishedAt
                                                var myUrl:NSURL?
                                                if let url: NSURL = NSURL(string: urlimage) {
                                                    myUrl = url
                                                } else if let url: NSURL = NSURL(string: urlimage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
                                                    myUrl = url
                                                }
                                            
                                               do {
                                                let imageData = try Data(contentsOf: myUrl! as URL)
                                                article.urlimage = imageData as NSData
                                               } catch {
                                                   print("Unable to load data: \(error)")
                                               }
                                                
       }
                                        }
                                     
                                     DispatchQueue.main.async {
                                         self?.persistence.save {
                                             self?.persistence.fetch(News.self, completion: {(objects) in
                                                 completion(objects)
                                                 print("Entitid:\(objects))")
                                             })
                                            
                                         }
                                     }
                                    }
                                }
                                
                            case.failure(let error):
                                self?.persistence.fetch(News.self, completion: {(objects) in
                                    completion(objects)
                                })

                            case .none:
                                print("error")
                            }
                          
                            
                         
                       }
    }
}


//
//  NewsCache.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import UIKit
import CoreData

class NewsCache{
    static let sharedInstance = NewsCache()
    
    private let appDelegate:AppDelegate
    private let managedContext:NSManagedObjectContext
    private let entity:NSEntityDescription?
    
    private init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: Constants.entityName,in: managedContext)
    }
    
    func save(article: Article) {
        guard let entity = entity else{
            print("cant find entity")
            return
        }
        
        let articles = NSManagedObject(entity: entity, insertInto: managedContext)
        articles.setValue(article.source.name, forKeyPath: Constants.articleSourceNameKey)
        articles.setValue(article.author, forKey: Constants.articleAuthorKey)
        articles.setValue(article.title, forKey: Constants.articleTitleKey)
        articles.setValue(article.description, forKey: Constants.articleDescriptionKey)
        articles.setValue(article.urlToImage, forKey: Constants.articleImageUrlKey)
        articles.setValue(article.url, forKey: Constants.articleUrlKey)
        
        do {
            try managedContext.save()
            print("Cache save successfully")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getNews(completion: @escaping ([Article]) -> Void) {
        var articles = [Article]()
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        do{
            let newsMngObj = try managedContext.fetch(fetchReq)
            for item in newsMngObj {
                if let sourceName = item.value(forKey: Constants.articleSourceNameKey) as? String,
                   let title = item.value(forKey: Constants.articleTitleKey) as? String {
                    let author = item.value(forKey: Constants.articleAuthorKey) as? String
                    let description = item.value(forKey: Constants.articleDescriptionKey) as? String
                    let imageUrl = item.value(forKey: Constants.articleImageUrlKey) as? String
                    let url = item.value(forKey: Constants.articleUrlKey) as? String
                    articles.append(Article(source: Source(id: nil, name: sourceName), author: author, title: title, description: description, url: url, urlToImage: imageUrl))
                }
            }
        } catch {
            print("Catch  GET")
        }
        print("Cached News", articles.count)
        completion(articles)
    }
    
    func deleteAll() {
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        do{
            let newsMngObj = try managedContext.fetch(fetchReq)
            for item in newsMngObj {
                managedContext.delete(item)
            }
        } catch {
            print("Catch  DLT")
        }
        print("DATA DELETED")
    }
}

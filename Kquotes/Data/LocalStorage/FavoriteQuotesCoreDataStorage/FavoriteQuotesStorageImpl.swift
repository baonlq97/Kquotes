//
//  FavoriteQuotesStorageImpl.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 11/09/2024.
//

import Foundation
import CoreData

final class FavoriteQuotesStorageImpl {
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(quote: Quote) -> NSFetchRequest<QuoteEntity> {
        let request: NSFetchRequest<QuoteEntity> = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "quote == %@", quote.quote)
        return request
    }

//    private func deleteResponse(
//        for requestDto: MoviesRequestDTO,
//        in context: NSManagedObjectContext
//    ) {
//        let request = fetchRequest(for: requestDto)
//
//        do {
//            if let result = try context.fetch(request).first {
//                context.delete(result)
//            }
//        } catch {
//            print(error)
//        }
//    }
}

extension FavoriteQuotesStorageImpl: FavoriteQuotesStorage {
    
    func fetchFavorites(
        completion: @escaping (Result<[Quote]?, Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = QuoteEntity.fetchRequest()
                let requestEntities = try context.fetch(request)

                completion(.success(QuoteEntity.toQuotes(requestEntities)))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(quote: Quote, completion: @escaping () -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                _ = quote.toEntity(in: context)
                try context.save()
                completion()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("FavoriteQuotesStorageImpl Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func delete(quote: Quote, completion: @escaping () -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                // Fetch request to get the entity matching the quote
                let fetchRequest = self.fetchRequest(quote: quote)
                
                // If a match is found, delete the entity
                do {
                    if let result = try context.fetch(fetchRequest).first {
                        context.delete(result)
                        try context.save()
                        completion()
                    }
                } catch {
                    throw(error)
                }
            } catch {
                // Handle any errors that occur during fetch or delete
                print("Failed to delete quote: \(error)")
            }
        }
    }
}

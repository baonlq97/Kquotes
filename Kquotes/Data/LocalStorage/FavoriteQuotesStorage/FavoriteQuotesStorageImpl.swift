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

//    private func fetchRequest() -> NSFetchRequest<MoviesRequestEntity> {
//        let request: NSFetchRequest = MoviesRequestEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
//                                        #keyPath(MoviesRequestEntity.query), requestDto.query,
//                                        #keyPath(MoviesRequestEntity.page), requestDto.page)
//        return request
//    }
//
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
}

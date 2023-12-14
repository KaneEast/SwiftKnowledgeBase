Apple 在 WWDC 23 中引入了 SwiftData。与 SwiftUI 类似，SwiftData 采用声明式方法。SwiftData 让我们可以使用声明性代码建模和管理数据，从而无需使用模型架构设计文件，并纯粹在 Swift 代码中引入数据查询和过滤，从而使数据持久化变得简单。

SwiftData 旨在与 UIKit 和 SwiftUI 一起使用，并且与 SwiftUI 无缝集成。

SwiftData 构建在 Core Data 之上，但它通过提供用 Swift 语言编写的本机 API 带来了现代数据持久化方法。

SwiftData 使用宏来生成代码。宏是 WWDC 23 中引入的另一个强大功能，它们用于生成快速、高效和安全的代码。

SwiftData 使用我们的模型自动构建模式，并将其字段有效地映射到底层存储。SwiftData 管理的对象会在需要时从数据库中获取，并在适当的时候自动保存，无需我们进行任何额外的工作。


```swift
import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var publishedYear: Int
    
    @Attribute(.externalStorage)
    var cover: Data?
    
    init(title: String, author: String, publishedYear: Int) {
        self.title = title
        self.author = author
        self.publishedYear = publishedYear
    }
}

```

```swift
import SwiftUI
import SwiftData

@main
struct ReadingLogDraftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Book.self])
        }
    }
}

@Environment(\.modelContext) private var context

@Query private var books: [Book]
@Query(sort: \Genre.name) private var genres: [Genre]
```

## relationships.

One to One(1:1) Relationship: In a one-to-one relationship, each entity instance on one side of the relationship is associated with exactly one entity instance on the other side, and vice versa. For example, we might have a “Person” entity with a one-to-one relationship to a “Passport” entity, where each person has only one passport.

One to Many(1:N) Relationship: In a one-to-many relationship, each entity instance on one side of the relationship can be associated with multiple entity instances on the other side, but each entity instance on the other side is associated with only one entity instance from the first side. For example, we might have a “Department” entity with a one-to-many relationship to an “Employee” entity, where each department can have many employees, but each employee belongs to only one department.

Many to One(N:1) Relationship: This is the inverse of a one-to-many relationship. Each entity instance on one side is associated with one entity instance on the other side, but each entity instance on the other side can be associated with multiple entity instances on the first side. Using the same “Department” and “Employee” example, this would mean that each employee belongs to one department, but multiple employees can belong to the same department.

Many to Many(N:N) Relationship: In a many-to-many relationship, multiple entity instances on one side can be associated with multiple entity instances on the other side. For example, we might have a “Student” entity, a “Course” entity, and a “Registration” entity to represent the many-to-many relationship between students and courses, where each registration links a student to a course.

```swift
import Foundation
import SwiftData

@Model
final class Note {
    var title: String
    var message: String
    var book: Book?
    
    init(title: String, message: String, book: Book? = nil) {
        self.title = title
        self.message = message
        self.book = book
    }
}
```

```swift
import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var publishedYear: Int
    
    @Relationship(deleteRule: .cascade, inverse: \Note.book)
    var notes = [Note]()
    
    init(title: String, author: String, publishedYear: Int) {
        self.title = title
        self.author = author
        self.publishedYear = publishedYear
    }
}
```

Notice that we are setting deleteRule for this relationship as cascade which indicates that upon deleting this book any related models will be deleted as well. Other delete rules include:

noAction: A rule that doesn’t make changes to the related models.
nullify: A rule that nullifies its related model’s reference.
deny: A rule that prevents the deletion of a model because it contains one or more references to the other models
cascade: A rule that deletes any related models.

```swift
import Foundation
import SwiftData

@Model
final class Book {
    ...
    
    @Relationship(deleteRule: .nullify, inverse: \Genre.books)
    var genres = [Genre]()
    
    init(title: String, author: String, publishedYear: Int) {
     ...
    }
}
```


```swift
let book = Book(title: title, author: author, publishedYear: publishedYear)
                        
context.insert(book)

do {
    try context.save()
} catch {
    print(error.localizedDescription)
}
```

```swift
guard let publishedYear else { return }
                        let book = Book(title: title, author: author, 
                                  publishedYear: publishedYear)

                        book.genres = Array(selectedGenres)
                        selectedGenres.forEach { genre in
                            genre.books.append(book)
                            context.insert(genre)
                        }

                        context.insert(book)
                        
                        ...
```


# migration
To manage database schema changes, SwiftData offers two strategies:

- Lightweight migration: Suitable when alterations don’t affect the stored data, such as changing table column names.

- Custom migration: Appropriate when there are alterations in the data storage rules, necessitating migration of existing customer data. For example, ensuring unique genre names without duplicates. This approach requires defining rules for data migration to avoid data loss during the transition.

```swift
import Foundation
import SwiftData
import UIKit

enum SchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Genre.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}

extension SchemaV1 {
    @Model
    final class Genre {
        var name: String
        var books = [Book]()
        
        @Attribute(.transformable(by: ColorTransformer.self))
        var color: UIColor
        
        init(name: String, color: UIColor) {
            self.name = name
            self.color = color
        }
    }
}
```


```
import Foundation
import SwiftData
import UIKit

enum SchemaV2: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Genre.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}

extension SchemaV2 {
    @Model
    final class Genre {
        var name: String
        var books = [Book]()
        
        @Attribute(.transformable(by: ColorTransformer.self))
        var color: UIColor
        
        init(name: String, color: UIColor) {
            self.name = name
            self.color = color
        }
    }
}
```

```
import Foundation
import SwiftData

enum ReadingLogMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [
            MigrationStage.lightweight(
                fromVersion: SchemaV1.self,
                toVersion: SchemaV2.self
            )
        ]
    }
}
```


```
import Foundation
import SwiftData
import UIKit

enum SchemaV3: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Genre.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(2, 0, 0)
}

extension SchemaV3 {
    @Model
    final class Genre {
        @Attribute(originalName: "name")
        var title: String
        var books = [Book]()
        
        @Attribute(.transformable(by: ColorTransformer.self))
        var color: UIColor
        
        init(name: String, color: UIColor) {
            self.title = name
            self.color = color
        }
    }
}

```



```
static var stages: [MigrationStage] {
        [
            MigrationStage.lightweight(
                fromVersion: SchemaV1.self,
                toVersion: SchemaV2.self
            ),
            
            MigrationStage.custom(
                fromVersion: SchemaV2.self,
                toVersion: SchemaV3.self,
                willMigrate: { context in
                    // nothing to do here
                },
                
                didMigrate: { context in
                    let genres = try? context.fetch(FetchDescriptor<SchemaV3.Genre>())
                    
                    genres?.forEach({ genre in
                        genre.desc = ""
                    })
                    
                    try? context.save()
                })
        ]
    }
    ```


enum SchemaV4: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Genre.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(2, 0, 0)
}

extension SchemaV4 {
    @Model
    final class Genre {
        @Attribute(.unique, originalName: "name")
        var title: String
        var books = [Book]()
        
        @Attribute(.transformable(by: ColorTransformer.self))
        var color: UIColor
        
        var desc: String = ""
        
        init(name: String, color: UIColor, desc: String = "") {
            self.title = name
            self.color = color
            self.desc = desc
        }
    }
}

import Foundation
import SwiftData

enum ReadingLogMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self, SchemaV3.self, SchemaV4.self]
    }
    
    

static var stages: [MigrationStage] {
        [
            MigrationStage.lightweight(
                fromVersion: SchemaV1.self,
                toVersion: SchemaV2.self
            ),
            
            MigrationStage.custom(
                fromVersion: SchemaV2.self,
                toVersion: SchemaV3.self,
                willMigrate: { context in
                    // nothing to do here
                },
                
                didMigrate: { context in
                    let genres = try? context.fetch(FetchDescriptor<SchemaV3.Genre>())
                    
                    genres?.forEach({ genre in
                        genre.desc = ""
                    })
                    
                    try? context.save()
                }),
            
            MigrationStage.custom(
                fromVersion: SchemaV3.self,
                toVersion: SchemaV4.self,
                willMigrate: { context in
                    let genres = try? context.fetch(FetchDescriptor<SchemaV4.Genre>())
                    
                    
                }, didMigrate: nil)
        ]
    }
}


import SwiftUI
import SwiftData
import TipKit

@main
struct ReadingLogDraftApp: App {
    let container: ModelContainer
    
    init() {
       ...
       
        do {
            container = try ModelContainer(for: Book.self, migrationPlan: ReadingLogMigrationPlan.self, configurations: ModelConfiguration(for: Book.self))
        } catch {
            fatalError("Failed to initialize the container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}



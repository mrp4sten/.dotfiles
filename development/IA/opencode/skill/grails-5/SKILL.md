---
name: grails-5
description: >
  Grails 5 framework patterns and best practices.
  Trigger: When working with Grails 5 applications - controllers, services, GORM, domains.
license: Apache-2.0
metadata:
  author: mrp4sten
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Working with Grails 5 applications"
    - "Creating Grails controllers or services"
    - "Designing GORM domain classes"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Grails 5 Overview

Grails is a powerful web framework built on top of Spring Boot and Groovy, following convention over configuration.

**Stack:**
- **Grails:** 5.x
- **Groovy:** 3.0.x
- **Spring Boot:** 2.7.x
- **GORM:** Grails Object Relational Mapping
- **Gradle:** Build tool

---

## Project Structure

```
grails-app/
├── conf/                   # Configuration
│   ├── application.yml     # Main config
│   ├── logback.groovy      # Logging config
│   └── spring/             # Spring beans
├── controllers/            # HTTP controllers
│   └── com/example/
│       └── UserController.groovy
├── domain/                 # GORM domain classes (models)
│   └── com/example/
│       └── User.groovy
├── services/               # Business logic (transactional)
│   └── com/example/
│       └── UserService.groovy
├── views/                  # GSP templates (if using server-side rendering)
│   └── user/
│       ├── index.gsp
│       └── show.gsp
├── i18n/                   # Internationalization
│   └── messages.properties
└── init/                   # Application initialization
    └── BootStrap.groovy

src/
├── main/
│   ├── groovy/             # Additional Groovy classes
│   └── resources/          # Static resources
└── test/
    └── groovy/             # Test classes
```

---

## Controllers

Controllers handle HTTP requests and return responses.

### Basic Controller

```groovy
package com.example

import grails.validation.ValidationException

class UserController {
    
    // Dependency injection (automatic)
    UserService userService
    
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond userService.list(params), model: [userCount: userService.count()]
    }
    
    def show(Long id) {
        respond userService.get(id)
    }
    
    def create() {
        respond new User(params)
    }
    
    def save(User user) {
        if (user == null) {
            notFound()
            return
        }
        
        try {
            userService.save(user)
        } catch (ValidationException e) {
            respond user.errors, view: 'create'
            return
        }
        
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect user
            }
            '*' { respond user, [status: CREATED] }
        }
    }
    
    def update(User user) {
        if (user == null) {
            notFound()
            return
        }
        
        try {
            userService.save(user)
        } catch (ValidationException e) {
            respond user.errors, view: 'edit'
            return
        }
        
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect user
            }
            '*' { respond user, [status: OK] }
        }
    }
    
    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }
        
        userService.delete(id)
        
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }
    
    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }
}
```

### REST Controller

```groovy
package com.example

import grails.rest.RestfulController

class UserController extends RestfulController<User> {
    
    static responseFormats = ['json', 'xml']
    
    UserController() {
        super(User)
    }
    
    // Override methods as needed
    @Override
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond User.list(params), [status: OK]
    }
}
```

---

## Services

Services contain business logic and are transactional by default.

### Service Best Practices

```groovy
package com.example

import grails.gorm.services.Service
import grails.gorm.transactions.Transactional

@Transactional
class UserService {
    
    // ✅ GOOD: Methods are transactional by default
    User save(User user) {
        user.save(flush: true, failOnError: true)
    }
    
    void delete(Long id) {
        User.get(id)?.delete(flush: true)
    }
    
    // ✅ GOOD: Read-only transactions for queries
    @Transactional(readOnly = true)
    User get(Long id) {
        User.get(id)
    }
    
    @Transactional(readOnly = true)
    List<User> list(Map args) {
        User.list(args)
    }
    
    @Transactional(readOnly = true)
    Long count() {
        User.count()
    }
    
    @Transactional(readOnly = true)
    List<User> findByEmail(String email) {
        User.findAllByEmailIlike("%${email}%")
    }
}
```

### GORM Data Services (Grails 5+)

```groovy
package com.example

import grails.gorm.services.Service

@Service(User)
interface UserDataService {
    
    User get(Serializable id)
    
    List<User> list(Map args)
    
    Long count()
    
    User save(User user)
    
    void delete(Serializable id)
    
    // Custom queries (auto-implemented by GORM)
    User findByEmail(String email)
    
    List<User> findAllByAgeGreaterThan(Integer age)
    
    List<User> findAllByEmailIlike(String email)
}
```

---

## Domain Classes (GORM)

Domain classes are persistent entities mapped to database tables.

### Basic Domain

```groovy
package com.example

import grails.gorm.annotation.Entity

@Entity
class User {
    
    String email
    String password
    String firstName
    String lastName
    Integer age
    Date dateCreated
    Date lastUpdated
    
    static constraints = {
        email nullable: false, blank: false, email: true, unique: true
        password nullable: false, blank: false, minSize: 8, maxSize: 128
        firstName nullable: false, blank: false, maxSize: 50
        lastName nullable: false, blank: false, maxSize: 50
        age nullable: true, min: 0, max: 150
    }
    
    static mapping = {
        table 'users'
        version false  // Disable optimistic locking if not needed
        id generator: 'identity'
    }
}
```

### Relationships

```groovy
package com.example

class Author {
    String name
    
    static hasMany = [books: Book]
    
    static constraints = {
        name nullable: false, blank: false
    }
}

class Book {
    String title
    Date publishDate
    
    static belongsTo = [author: Author]
    
    static constraints = {
        title nullable: false, blank: false
        publishDate nullable: true
    }
}

// Usage:
def author = new Author(name: "Martin Fowler")
author.addToBooks(new Book(title: "Refactoring"))
author.addToBooks(new Book(title: "Patterns of Enterprise Application Architecture"))
author.save(flush: true)
```

### Validation

```groovy
class User {
    
    String email
    String password
    String username
    
    static constraints = {
        email nullable: false, blank: false, email: true, unique: true
        password nullable: false, blank: false, minSize: 8, validator: { val, obj ->
            // Custom validator
            if (!val.matches(/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+$/)) {
                return 'password.weak'
            }
        }
        username nullable: false, blank: false, unique: true, matches: /^[a-zA-Z0-9_]+$/
    }
    
    static mapping = {
        password column: 'passwd'  // Map to different column name
    }
}
```

---

## GORM Queries

### Dynamic Finders

```groovy
// Find by property
User.findByEmail("john@example.com")
User.findByEmailAndAge("john@example.com", 30)

// Find all matching
User.findAllByAgeGreaterThan(18)
User.findAllByEmailIlike("%@gmail.com")

// Count
User.countByAgeGreaterThan(18)

// List with pagination
User.list(max: 10, offset: 0, sort: "lastName", order: "asc")
```

### Criteria Queries

```groovy
def users = User.createCriteria().list {
    eq('age', 30)
    ilike('email', '%@gmail.com')
    order('lastName', 'asc')
    maxResults(10)
}

// Complex criteria
def users = User.createCriteria().list {
    or {
        eq('age', 30)
        eq('age', 40)
    }
    ilike('email', '%@gmail.com')
    between('dateCreated', startDate, endDate)
}
```

### HQL (Hibernate Query Language)

```groovy
def users = User.executeQuery(
    "FROM User WHERE email LIKE :email AND age > :age",
    [email: "%@gmail.com", age: 18]
)

// With pagination
def users = User.executeQuery(
    "FROM User WHERE age > :age ORDER BY lastName",
    [age: 18],
    [max: 10, offset: 0]
)
```

---

## Configuration

### application.yml

```yaml
grails:
    profile: web
    codegen:
        defaultPackage: com.example
    gorm:
        reactor:
            # Whether to translate GORM events into Reactor events
            events: false
    cors:
        enabled: true
        allowedOrigins:
            - http://localhost:3000
            - https://app.example.com
        allowedMethods:
            - GET
            - POST
            - PUT
            - DELETE
            - OPTIONS
        allowedHeaders:
            - Content-Type
            - Authorization

environments:
    development:
        dataSource:
            dbCreate: create-drop
            url: jdbc:h2:mem:devDb;LOCK_TIMEOUT=10000;DB_CLOSE_ON_EXIT=FALSE
    test:
        dataSource:
            dbCreate: update
            url: jdbc:h2:mem:testDb;LOCK_TIMEOUT=10000;DB_CLOSE_ON_EXIT=FALSE
    production:
        dataSource:
            dbCreate: update
            url: jdbc:mysql://localhost/mydb
            username: dbuser
            password: ${DB_PASSWORD}
            properties:
                jmxEnabled: true
                initialSize: 5
                maxActive: 50
                minIdle: 5
                maxIdle: 25
```

---

## Dependency Injection

Grails uses Spring for dependency injection.

### Field Injection (Automatic)

```groovy
class UserController {
    
    // ✅ Automatically injected by name
    UserService userService
    EmailService emailService
    
    def index() {
        def users = userService.list()
        respond users
    }
}
```

### Constructor Injection (Recommended)

```groovy
class UserController {
    
    private final UserService userService
    
    UserController(UserService userService) {
        this.userService = userService
    }
    
    def index() {
        respond userService.list()
    }
}
```

---

## URL Mappings

Define custom URL patterns in `grails-app/controllers/UrlMappings.groovy`:

```groovy
class UrlMappings {

    static mappings = {
        
        // Default mapping
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        
        // REST resources
        "/api/users"(resources: "user")
        
        // Custom routes
        "/api/users/search/$email"(controller: "user", action: "search")
        
        // Static routes
        "/"(view:"/index")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
```

---

## Common Patterns

### Handling JSON

```groovy
class UserController {
    
    def save() {
        // Parse JSON from request
        def json = request.JSON
        
        def user = new User(
            email: json.email,
            firstName: json.firstName,
            lastName: json.lastName
        )
        
        if (!user.save(flush: true)) {
            render status: 400, json: [errors: user.errors]
            return
        }
        
        render status: 201, json: user
    }
}
```

### File Upload

```groovy
class FileController {
    
    def upload() {
        def file = request.getFile('file')
        
        if (file.empty) {
            render status: 400, text: 'File is empty'
            return
        }
        
        def uploadDir = new File('uploads')
        if (!uploadDir.exists()) {
            uploadDir.mkdirs()
        }
        
        def filename = "${UUID.randomUUID()}_${file.originalFilename}"
        file.transferTo(new File(uploadDir, filename))
        
        render status: 200, json: [filename: filename]
    }
}
```

### Pagination Helper

```groovy
class UserController {
    
    UserService userService
    
    def index() {
        params.max = Math.min(params.max as Integer ?: 10, 100)
        params.offset = params.offset as Integer ?: 0
        
        def users = userService.list(params)
        def total = userService.count()
        
        render(
            status: 200,
            json: [
                data: users,
                pagination: [
                    total: total,
                    max: params.max,
                    offset: params.offset,
                    hasMore: (params.offset + params.max) < total
                ]
            ]
        )
    }
}
```

---

## Testing (See spock and grails-tdd skills)

```groovy
// See spock.md for Spock testing patterns
// See grails-tdd.md for Grails-specific TDD workflow
```

---

## Common Gotchas

### 1. Flush and FailOnError

```groovy
// ❌ BAD (Silent failure)
user.save()

// ✅ GOOD (Throws exception on validation error)
user.save(failOnError: true)

// ✅ GOOD (Immediately persist to database)
user.save(flush: true)

// ✅ BEST (Both)
user.save(flush: true, failOnError: true)
```

### 2. Transactional Scope

```groovy
// ❌ BAD (No transaction)
class UserHelper {
    def saveUser(User user) {
        user.save(flush: true)  // May cause issues
    }
}

// ✅ GOOD (Service is transactional)
@Transactional
class UserService {
    def save(User user) {
        user.save(flush: true, failOnError: true)
    }
}
```

### 3. N+1 Query Problem

```groovy
// ❌ BAD (N+1 queries)
def authors = Author.list()
authors.each { author ->
    println author.books  // Separate query for each author
}

// ✅ GOOD (Eager fetching)
def authors = Author.list(fetch: [books: 'eager'])
authors.each { author ->
    println author.books  // Already loaded
}
```

---

## Resources

- **Grails 5 Documentation:** https://docs.grails.org/5.3.2/
- **GORM Documentation:** https://gorm.grails.org/
- **Groovy Documentation:** https://groovy-lang.org/documentation.html
- **Spring Boot (underlying):** https://spring.io/projects/spring-boot

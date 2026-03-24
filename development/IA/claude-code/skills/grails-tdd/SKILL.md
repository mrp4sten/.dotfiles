---
name: grails-tdd
description: >
  Test-Driven Development workflow for Grails applications with Spock.
  Trigger: When implementing features, fixing bugs, or refactoring in Grails projects.
license: Apache-2.0
metadata:
  author: mrp4sten
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Implementing features in Grails"
    - "Fixing bugs in Grails applications"
    - "Refactoring Grails code"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Grails TDD Workflow

Test-Driven Development applied to Grails applications using Spock framework.

**Core Principle:** Write test first, make it pass, then refactor.

---

## TDD Cycle (Red-Green-Refactor)

```
1. RED    → Write a failing test
2. GREEN  → Write minimal code to pass
3. REFACTOR → Improve code quality
4. REPEAT
```

---

## Test Levels in Grails

### 1. Unit Tests (Fast, Isolated)

Test individual classes in isolation.

**Location:** `src/test/groovy/`

**Traits:**
- `ControllerUnitTest` — For controllers
- `ServiceUnitTest` — For services
- `DataTest` — For domain classes (GORM mocking)

### 2. Integration Tests (Full Stack)

Test with real database and Spring context.

**Location:** `src/integration-test/groovy/`

**Annotations:**
- `@Integration` — Loads full Grails application
- `@Rollback` — Rolls back database changes after each test

---

## TDD Workflow Example: Create User Feature

### Step 1: Write Failing Domain Test (RED)

```groovy
// src/test/groovy/com/example/UserSpec.groovy
package com.example

import grails.testing.gorm.DataTest
import spock.lang.Specification

class UserSpec extends Specification implements DataTest {
    
    def setup() {
        mockDomain(User)
    }
    
    void "should create user with valid data"() {
        given: "valid user data"
        def user = new User(
            email: "john@example.com",
            firstName: "John",
            lastName: "Doe",
            password: "secret123"
        )
        
        when: "saving the user"
        user.save()
        
        then: "user is persisted"
        user.id != null
        !user.hasErrors()
        User.count() == 1
    }
    
    void "should fail validation when email is missing"() {
        given: "user without email"
        def user = new User(
            firstName: "John",
            lastName: "Doe",
            password: "secret123"
        )
        
        when: "validating the user"
        user.validate()
        
        then: "validation fails"
        user.hasErrors()
        user.errors.getFieldError('email') != null
    }
}
```

**Run test:**
```bash
./gradlew test --tests UserSpec
```

**Result:** ❌ FAILS (User class doesn't exist yet)

---

### Step 2: Create Domain Class (GREEN)

```groovy
// grails-app/domain/com/example/User.groovy
package com.example

class User {
    
    String email
    String firstName
    String lastName
    String password
    Date dateCreated
    Date lastUpdated
    
    static constraints = {
        email nullable: false, blank: false, email: true, unique: true
        firstName nullable: false, blank: false
        lastName nullable: false, blank: false
        password nullable: false, blank: false, minSize: 8
    }
    
    static mapping = {
        table 'users'
        version false
    }
}
```

**Run test:**
```bash
./gradlew test --tests UserSpec
```

**Result:** ✅ PASSES

---

### Step 3: Write Failing Service Test (RED)

```groovy
// src/test/groovy/com/example/UserServiceSpec.groovy
package com.example

import grails.testing.gorm.DataTest
import grails.testing.services.ServiceUnitTest
import spock.lang.Specification

class UserServiceSpec extends Specification implements ServiceUnitTest<UserService>, DataTest {
    
    def setup() {
        mockDomain(User)
    }
    
    void "should create user successfully"() {
        given: "valid user data"
        def dto = [
            email: "john@example.com",
            firstName: "John",
            lastName: "Doe",
            password: "secret123"
        ]
        
        when: "creating user"
        def user = service.create(dto)
        
        then: "user is created"
        user != null
        user.id != null
        user.email == "john@example.com"
        User.count() == 1
    }
    
    void "should hash password before saving"() {
        given: "user data with plain text password"
        def dto = [
            email: "john@example.com",
            firstName: "John",
            lastName: "Doe",
            password: "secret123"
        ]
        
        when: "creating user"
        def user = service.create(dto)
        
        then: "password is hashed"
        user.password != "secret123"
        user.password.length() > 20
    }
    
    void "should throw exception when email already exists"() {
        given: "existing user"
        new User(
            email: "john@example.com",
            firstName: "John",
            lastName: "Doe",
            password: "hashed"
        ).save(flush: true)
        
        and: "new user with same email"
        def dto = [
            email: "john@example.com",
            firstName: "Jane",
            lastName: "Smith",
            password: "secret456"
        ]
        
        when: "creating user"
        service.create(dto)
        
        then: "exception is thrown"
        thrown(grails.validation.ValidationException)
    }
}
```

**Run test:**
```bash
./gradlew test --tests UserServiceSpec
```

**Result:** ❌ FAILS (UserService doesn't exist)

---

### Step 4: Create Service (GREEN)

```groovy
// grails-app/services/com/example/UserService.groovy
package com.example

import grails.gorm.transactions.Transactional
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

@Transactional
class UserService {
    
    BCryptPasswordEncoder passwordEncoder
    
    User create(Map dto) {
        def user = new User(
            email: dto.email,
            firstName: dto.firstName,
            lastName: dto.lastName,
            password: passwordEncoder.encode(dto.password)
        )
        
        user.save(flush: true, failOnError: true)
        return user
    }
    
    @Transactional(readOnly = true)
    User get(Long id) {
        User.get(id)
    }
    
    @Transactional(readOnly = true)
    List<User> list(Map params) {
        User.list(params)
    }
    
    void delete(Long id) {
        User.get(id)?.delete(flush: true)
    }
}
```

**Configure BCrypt in** `grails-app/conf/spring/resources.groovy`:

```groovy
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

beans = {
    passwordEncoder(BCryptPasswordEncoder)
}
```

**Run test:**
```bash
./gradlew test --tests UserServiceSpec
```

**Result:** ✅ PASSES

---

### Step 5: Write Failing Controller Test (RED)

```groovy
// src/test/groovy/com/example/UserControllerSpec.groovy
package com.example

import grails.testing.gorm.DataTest
import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class UserControllerSpec extends Specification 
    implements ControllerUnitTest<UserController>, DataTest {
    
    def setup() {
        mockDomain(User)
    }
    
    void "should return list of users"() {
        given: "existing users"
        new User(email: "a@test.com", firstName: "Alice", lastName: "A", password: "hash1").save()
        new User(email: "b@test.com", firstName: "Bob", lastName: "B", password: "hash2").save()
        
        when: "requesting user list"
        controller.index()
        
        then: "users are returned"
        response.status == 200
        response.json.size() == 2
        response.json[0].email == "a@test.com"
    }
    
    void "should create user with valid data"() {
        given: "valid user data"
        request.json = [
            email: "john@test.com",
            firstName: "John",
            lastName: "Doe",
            password: "secret123"
        ]
        
        when: "creating user"
        controller.save()
        
        then: "user is created"
        response.status == 201
        response.json.id != null
        response.json.email == "john@test.com"
        User.count() == 1
    }
    
    void "should return 400 when validation fails"() {
        given: "invalid user data (missing email)"
        request.json = [
            firstName: "John",
            lastName: "Doe",
            password: "secret123"
        ]
        
        when: "creating user"
        controller.save()
        
        then: "validation error is returned"
        response.status == 400
        response.json.errors != null
    }
}
```

**Run test:**
```bash
./gradlew test --tests UserControllerSpec
```

**Result:** ❌ FAILS (UserController doesn't exist)

---

### Step 6: Create Controller (GREEN)

```groovy
// grails-app/controllers/com/example/UserController.groovy
package com.example

import grails.validation.ValidationException

class UserController {
    
    UserService userService
    
    static responseFormats = ['json']
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    
    def index() {
        respond userService.list(params)
    }
    
    def show(Long id) {
        respond userService.get(id)
    }
    
    def save() {
        try {
            def user = userService.create(request.JSON)
            respond user, [status: 201]
        } catch (ValidationException e) {
            respond([errors: e.errors], [status: 400])
        }
    }
    
    def delete(Long id) {
        userService.delete(id)
        render status: 204
    }
}
```

**Run test:**
```bash
./gradlew test --tests UserControllerSpec
```

**Result:** ✅ PASSES

---

### Step 7: Integration Test (Full Stack)

```groovy
// src/integration-test/groovy/com/example/UserIntegrationSpec.groovy
package com.example

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import io.micronaut.http.HttpRequest
import io.micronaut.http.HttpStatus
import io.micronaut.http.client.HttpClient

@Integration
@Rollback
class UserIntegrationSpec extends Specification {
    
    HttpClient client
    
    void setup() {
        client = HttpClient.create(new URL("http://localhost:${serverPort}"))
    }
    
    void cleanup() {
        client.close()
    }
    
    void "should create user via REST API"() {
        given: "user data"
        def body = [
            email: "integration@test.com",
            firstName: "Integration",
            lastName: "Test",
            password: "secret123"
        ]
        
        when: "posting to /user"
        def request = HttpRequest.POST("/user", body)
        def response = client.toBlocking().exchange(request, Map)
        
        then: "user is created"
        response.status == HttpStatus.CREATED
        response.body().id != null
        response.body().email == "integration@test.com"
        
        and: "user is persisted in database"
        User.count() == 1
        User.findByEmail("integration@test.com") != null
    }
}
```

**Run integration test:**
```bash
./gradlew integrationTest --tests UserIntegrationSpec
```

---

## TDD Best Practices for Grails

### 1. Test Naming Convention

```groovy
// ✅ Good (Descriptive)
void "should create user when valid data is provided"() { ... }
void "should throw ValidationException when email is duplicate"() { ... }
void "should return 404 when user ID does not exist"() { ... }

// ❌ Bad (Not descriptive)
void "testCreateUser"() { ... }
void "test1"() { ... }
```

### 2. Use Appropriate Test Type

| Scenario | Test Type | Why |
|----------|-----------|-----|
| Validate domain constraints | Unit Test | Fast, no database |
| Test service business logic | Unit Test | Mock dependencies |
| Test controller JSON response | Unit Test | Mock service |
| Test database queries | Integration Test | Real database needed |
| Test full API flow | Integration Test | End-to-end validation |

### 3. Mock External Dependencies

```groovy
class UserServiceSpec extends Specification implements ServiceUnitTest<UserService> {
    
    void "should send welcome email"() {
        given: "mocked email service"
        def emailService = Mock(EmailService)
        service.emailService = emailService
        
        when:
        service.create([email: "john@test.com", ...])
        
        then:
        1 * emailService.sendWelcomeEmail("john@test.com")
    }
}
```

### 4. Test Edge Cases

```groovy
void "should handle null email gracefully"() { ... }
void "should handle very long names (> 255 chars)"() { ... }
void "should handle SQL injection in search"() { ... }
void "should handle concurrent user creation"() { ... }
```

### 5. Keep Tests Independent

```groovy
// ❌ Bad (Tests depend on each other)
void "test1 creates user"() {
    user = new User(...).save()
}

void "test2 updates user"() {
    user.firstName = "Updated"  // Depends on test1
}

// ✅ Good (Each test is independent)
void "should create user"() {
    def user = new User(...).save()
    assert user.id != null
}

void "should update user"() {
    def user = new User(...).save()  // Creates own fixture
    user.firstName = "Updated"
}
```

---

## Running Tests

### All Tests

```bash
./gradlew test
```

### Specific Test Class

```bash
./gradlew test --tests UserServiceSpec
```

### Specific Test Method

```bash
./gradlew test --tests UserServiceSpec."should create user successfully"
```

### Integration Tests

```bash
./gradlew integrationTest
```

### Continuous Testing (Watch Mode)

```bash
./gradlew test --continuous
```

### Test Report

After running tests, view report at:
```
build/reports/tests/test/index.html
```

---

## Test Coverage

### JaCoCo Plugin

Add to `build.gradle`:

```gradle
plugins {
    id 'jacoco'
}

jacoco {
    toolVersion = "0.8.8"
}

test {
    finalizedBy jacocoTestReport
}

jacocoTestReport {
    dependsOn test
    reports {
        xml.enabled true
        html.enabled true
    }
}
```

**Generate coverage report:**
```bash
./gradlew test jacocoTestReport
```

**View report:**
```
build/reports/jacoco/test/html/index.html
```

---

## Common Patterns

### Testing GORM Queries

```groovy
void "should find users by email domain"() {
    given: "users with different email domains"
    new User(email: "alice@gmail.com", ...).save()
    new User(email: "bob@gmail.com", ...).save()
    new User(email: "charlie@yahoo.com", ...).save()
    
    when: "finding Gmail users"
    def users = User.findAllByEmailIlike("%@gmail.com")
    
    then:
    users.size() == 2
    users*.email == ["alice@gmail.com", "bob@gmail.com"]
}
```

### Testing Transactions

```groovy
void "should rollback on error"() {
    given:
    def user = new User(...).save(flush: true)
    
    when: "update fails"
    user.email = null  // Invalid
    user.save(flush: true, failOnError: true)
    
    then:
    thrown(ValidationException)
    
    and: "transaction is rolled back"
    User.get(user.id).email != null  // Original value restored
}
```

### Testing Async Operations

```groovy
void "should process async task"() {
    given:
    def latch = new CountDownLatch(1)
    def result
    
    when:
    service.processAsync { data ->
        result = data
        latch.countDown()
    }
    
    then:
    latch.await(5, TimeUnit.SECONDS)
    result != null
}
```

---

## TDD Anti-Patterns (Avoid)

### ❌ Testing Implementation Details

```groovy
// Bad
void "should call repository.save()"() {
    then:
    1 * repository.save(_)  // Don't test internal calls
}

// Good
void "should persist user"() {
    when:
    service.create(dto)
    
    then:
    User.count() == 1  // Test outcome, not implementation
}
```

### ❌ Mocking Everything

```groovy
// Bad
def user = Mock(User)
def service = Mock(UserService)
// Testing mocks, not real code!

// Good
def user = new User(...)  // Use real objects when possible
```

### ❌ Testing Getters/Setters

```groovy
// Bad
void "should set email"() {
    user.setEmail("test@test.com")
    assert user.getEmail() == "test@test.com"
}

// These are auto-generated, no need to test!
```

---

## Resources

- **Grails Testing:** https://testing.grails.org/
- **Spock Framework:** https://spockframework.org/
- **TDD by Example (Kent Beck):** Classic TDD book
- **Growing Object-Oriented Software (Freeman & Pryce):** Test-driven design

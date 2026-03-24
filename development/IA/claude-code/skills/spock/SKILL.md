---
name: spock
description: >
  Spock testing framework for Groovy and Java applications.
  Trigger: When writing tests with Spock - specifications, mocking, data-driven tests.
license: Apache-2.0
metadata:
  author: mrp4sten
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Writing Spock tests"
    - "Creating test specifications"
    - "Mocking dependencies with Spock"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Spock Framework Overview

Spock is a testing and specification framework for Java and Groovy applications, inspired by JUnit, RSpec, jMock, Mockito, and more.

**Key Features:**
- **Expressive syntax:** Given-When-Then blocks
- **Built-in mocking:** No separate library needed
- **Data-driven testing:** Where blocks for parameterized tests
- **Groovy power:** Leverage Groovy's dynamic features

---

## Test Structure (Specification)

Spock tests extend `Specification` class and use labeled blocks.

```groovy
import spock.lang.Specification

class UserServiceSpec extends Specification {
    
    // Fixture methods (optional)
    def setup() {
        // Runs before each test
    }
    
    def cleanup() {
        // Runs after each test
    }
    
    def setupSpec() {
        // Runs once before all tests
    }
    
    def cleanupSpec() {
        // Runs once after all tests
    }
    
    // Test methods
    def "should create user with valid data"() {
        given: "a valid user DTO"
        def dto = new CreateUserDto(
            email: "john@example.com",
            firstName: "John",
            lastName: "Doe"
        )
        
        when: "creating the user"
        def user = service.create(dto)
        
        then: "user is created successfully"
        user.id != null
        user.email == "john@example.com"
        user.firstName == "John"
        user.lastName == "Doe"
    }
}
```

---

## Labeled Blocks

### given (or setup)

Setup the test fixture.

```groovy
def "should calculate total price"() {
    given: "a shopping cart with items"
    def cart = new ShoppingCart()
    cart.addItem(new Item(price: 10, quantity: 2))
    cart.addItem(new Item(price: 5, quantity: 3))
    
    when:
    def total = cart.calculateTotal()
    
    then:
    total == 35  // (10 * 2) + (5 * 3)
}
```

### when

Invoke the code under test (action).

```groovy
when: "user logs in with valid credentials"
def result = authService.login("john@example.com", "password123")
```

### then

Verify the outcome (assertions).

```groovy
then: "login is successful"
result.success == true
result.token != null
result.user.email == "john@example.com"
```

### expect

Combine when + then for simple assertions.

```groovy
def "should add two numbers"() {
    expect:
    calculator.add(2, 3) == 5
    calculator.add(10, -5) == 5
    calculator.add(0, 0) == 0
}
```

### where

Data-driven testing (parameterized tests).

```groovy
def "should validate email format"() {
    expect:
    validator.isValidEmail(email) == isValid
    
    where:
    email                  | isValid
    "john@example.com"     | true
    "invalid.email"        | false
    "test@test"            | false
    "user+tag@domain.com"  | true
    ""                     | false
}
```

---

## Assertions

Spock assertions are simple Groovy boolean expressions.

### Basic Assertions

```groovy
then:
user.id != null               // Not null
user.email == "john@test.com" // Equality
user.age > 18                 // Comparison
user.active == true           // Boolean
!user.deleted                 // Negation
```

### Collection Assertions

```groovy
then:
users.size() == 3
users*.email == ["a@test.com", "b@test.com", "c@test.com"]  // Spread operator
users.every { it.age >= 18 }  // All elements
users.any { it.admin }        // At least one
users.find { it.email == "a@test.com" } != null
```

### Exception Assertions

```groovy
when:
service.delete(999)

then:
thrown(NotFoundException)

// With message check
def e = thrown(NotFoundException)
e.message == "User not found: 999"

// No exception thrown
notThrown(Exception)
```

### Old Values (Compare Before/After)

```groovy
when:
user.age = 30

then:
old(user.age) == 25  // Value before when block
user.age == 30       // Value after when block
```

---

## Mocking

Spock has built-in mocking without external libraries.

### Creating Mocks

```groovy
def "should send email when user is created"() {
    given: "a mocked email service"
    def emailService = Mock(EmailService)
    def userService = new UserService(emailService: emailService)
    
    and: "a user DTO"
    def dto = new CreateUserDto(email: "john@test.com", firstName: "John")
    
    when: "creating the user"
    userService.create(dto)
    
    then: "email is sent"
    1 * emailService.sendWelcomeEmail("john@test.com")  // Called exactly once
}
```

### Mock Interaction Verification

```groovy
then:
1 * emailService.send(_)                          // Called once with any argument
2 * emailService.send("john@test.com")            // Called twice with specific argument
(1..3) * emailService.send(_)                     // Called 1 to 3 times
0 * emailService.send(_)                          // Never called
_ * emailService.send(_)                          // Called any number of times (including zero)
1 * emailService.send({ it.contains("@") })       // Called with argument matching closure
```

### Return Values from Mocks

```groovy
def "should use mocked repository"() {
    given:
    def repository = Mock(UserRepository)
    repository.findById(1) >> new User(id: 1, email: "john@test.com")  // Returns value
    repository.findById(2) >> null                                      // Returns null
    repository.findAll() >> [new User(id: 1), new User(id: 2)]          // Returns list
    
    when:
    def user = repository.findById(1)
    
    then:
    user.email == "john@test.com"
}
```

### Multiple Return Values

```groovy
given:
def service = Mock(ExternalService)
service.fetchData() >>> [
    "first call",
    "second call",
    "third call"
]

expect:
service.fetchData() == "first call"
service.fetchData() == "second call"
service.fetchData() == "third call"
```

### Throwing Exceptions from Mocks

```groovy
given:
def service = Mock(ExternalService)
service.fetchData() >> { throw new TimeoutException("Connection timeout") }

when:
service.fetchData()

then:
thrown(TimeoutException)
```

---

## Stubs vs Mocks vs Spies

### Stub (Only Returns Values)

```groovy
def repository = Stub(UserRepository)
repository.findById(1) >> new User(id: 1, email: "john@test.com")

// No interaction verification possible with stubs
```

### Mock (Returns Values + Verifies Interactions)

```groovy
def emailService = Mock(EmailService)
emailService.send(_) >> true

// Can verify interactions
1 * emailService.send("john@test.com")
```

### Spy (Partial Mock - Real Object)

```groovy
def realService = new UserService()
def service = Spy(realService)

// Some methods use real implementation, others are mocked
service.validate(_) >> true  // Mock this method
// service.save() uses real implementation
```

---

## Data-Driven Testing (where)

### Basic Data Table

```groovy
def "should calculate discount"() {
    expect:
    calculateDiscount(price, discountRate) == expectedPrice
    
    where:
    price | discountRate || expectedPrice
    100   | 0.1          || 90
    100   | 0.5          || 50
    50    | 0.2          || 40
}
```

### Multiple Parameter Sets

```groovy
def "should validate password strength"() {
    expect:
    validator.isStrong(password) == isStrong
    
    where:
    password      || isStrong
    "Abcd1234"    || true
    "weakpass"    || false
    "NoDigits!"   || false
    "NoUppers1"   || false
    "Strong#123"  || true
}
```

### Data Pipes

```groovy
def "should validate email domains"() {
    expect:
    validator.isValidDomain(email) == isValid
    
    where:
    email << ["user@gmail.com", "user@yahoo.com", "user@invalid"]
    isValid << [true, true, false]
}
```

### Derived Values

```groovy
def "should calculate total with tax"() {
    expect:
    calculateTotal(price, taxRate) == expectedTotal
    
    where:
    price | taxRate
    100   | 0.1
    50    | 0.2
    200   | 0.15
    
    expectedTotal = price * (1 + taxRate)  // Derived column
}
```

### Unrolling (Individual Test Names)

```groovy
@Unroll
def "should validate #email as #description"() {
    expect:
    validator.isValid(email) == isValid
    
    where:
    email                | isValid | description
    "valid@test.com"     | true    | "valid email"
    "invalid.email"      | false   | "invalid email"
    "no-at-sign.com"     | false   | "missing @ sign"
}
```

---

## Testing Grails Applications

### Unit Tests (Fast, Isolated)

```groovy
import grails.testing.gorm.DataTest
import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class UserControllerSpec extends Specification implements ControllerUnitTest<UserController>, DataTest {
    
    def setup() {
        mockDomain(User)
    }
    
    def "should list users"() {
        given:
        new User(email: "a@test.com", firstName: "Alice").save()
        new User(email: "b@test.com", firstName: "Bob").save()
        
        when:
        controller.index()
        
        then:
        response.status == 200
        response.json.size() == 2
    }
}
```

### Integration Tests (Full Stack)

```groovy
import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification

@Integration
@Rollback
class UserServiceIntegrationSpec extends Specification {
    
    UserService userService
    
    def "should create and persist user"() {
        given:
        def dto = new CreateUserDto(
            email: "john@test.com",
            firstName: "John",
            lastName: "Doe"
        )
        
        when:
        def user = userService.create(dto)
        
        then:
        user.id != null
        User.count() == 1
        User.findByEmail("john@test.com") != null
    }
}
```

---

## Common Patterns

### Setup with Multiple Givens

```groovy
def "should process order"() {
    given: "a user"
    def user = new User(email: "john@test.com")
    
    and: "a shopping cart"
    def cart = new ShoppingCart(user: user)
    cart.addItem(new Item(price: 10, quantity: 2))
    
    and: "a payment service"
    def paymentService = Mock(PaymentService)
    paymentService.charge(_, _) >> true
    
    when:
    def order = orderService.checkout(cart)
    
    then:
    order.total == 20
    1 * paymentService.charge(user, 20)
}
```

### Conditional Test Execution

```groovy
@IgnoreIf({ System.getenv("CI") == "true" })
def "should connect to external API"() {
    // Only runs locally, not in CI
}

@Requires({ os.windows })
def "should test Windows-specific feature"() {
    // Only runs on Windows
}
```

### Timeout

```groovy
@Timeout(5)  // Seconds
def "should complete within 5 seconds"() {
    expect:
    slowService.process()
}
```

### Shared Resources

```groovy
class UserServiceSpec extends Specification {
    
    @Shared  // Shared across all tests
    def database
    
    def setupSpec() {
        database = new InMemoryDatabase()
    }
    
    def cleanupSpec() {
        database.close()
    }
}
```

---

## Best Practices

### 1. Descriptive Test Names

```groovy
// ❌ Bad
def "test1"() { ... }

// ✅ Good
def "should return empty list when no users exist"() { ... }
def "should throw NotFoundException when user ID is invalid"() { ... }
```

### 2. One Concept Per Test

```groovy
// ❌ Bad (Testing multiple things)
def "user operations"() {
    expect:
    service.create(dto1)
    service.update(dto2)
    service.delete(id)
}

// ✅ Good (Separate tests)
def "should create user"() { ... }
def "should update user"() { ... }
def "should delete user"() { ... }
```

### 3. Use given-when-then

```groovy
// ✅ Good (Clear structure)
def "should calculate total"() {
    given: "a cart with items"
    def cart = createCart()
    
    when: "calculating total"
    def total = cart.calculateTotal()
    
    then: "total is correct"
    total == 100
}
```

### 4. Mock Only External Dependencies

```groovy
// ✅ Good (Mock external service)
def emailService = Mock(EmailService)

// ❌ Bad (Don't mock class under test)
def userService = Mock(UserService)  // Testing a mock!
```

---

## Assertion Messages

Spock provides detailed assertion failure messages automatically:

```groovy
expect:
user.email == "expected@test.com"

// Failure output:
// Condition not satisfied:
// user.email == "expected@test.com"
// |    |     |
// |    |     false
// |    "actual@test.com"
// User(id: 1, email: "actual@test.com", ...)
```

---

## Resources

- **Spock Framework:** https://spockframework.org/
- **Spock Documentation:** https://spockframework.org/spock/docs/2.3/
- **Groovy Documentation:** https://groovy-lang.org/documentation.html
- **Grails Testing:** https://testing.grails.org/

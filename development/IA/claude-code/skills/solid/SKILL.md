---
name: solid
description: >
  SOLID principles for object-oriented design.
  Trigger: When designing classes, refactoring code, or reviewing architecture.
license: Apache-2.0
metadata:
  author: mrp4sten
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Designing classes or interfaces"
    - "Refactoring object-oriented code"
    - "Reviewing class architecture"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## SOLID Principles Overview

Five principles for maintainable, scalable object-oriented design:

1. **S**ingle Responsibility Principle (SRP)
2. **O**pen/Closed Principle (OCP)
3. **L**iskov Substitution Principle (LSP)
4. **I**nterface Segregation Principle (ISP)
5. **D**ependency Inversion Principle (DIP)

---

## 1. Single Responsibility Principle (SRP)

> A class should have only one reason to change.

Each class should focus on a single responsibility or concern.

### ❌ Bad (Multiple Responsibilities)

```typescript
class UserManager {
  saveUser(user: User) {
    // Validate user
    if (!user.email.includes('@')) throw new Error('Invalid email');
    
    // Save to database
    db.insert('users', user);
    
    // Send email
    emailService.send(user.email, 'Welcome!');
    
    // Log activity
    logger.info(`User ${user.id} created`);
  }
}
```

**Problems:**
- Mixes validation, persistence, notification, and logging
- Changes to email logic require modifying UserManager
- Hard to test in isolation

### ✅ Good (Single Responsibility)

```typescript
class UserValidator {
  validate(user: User): void {
    if (!user.email.includes('@')) {
      throw new Error('Invalid email');
    }
  }
}

class UserRepository {
  save(user: User): void {
    db.insert('users', user);
  }
}

class UserNotifier {
  sendWelcomeEmail(user: User): void {
    emailService.send(user.email, 'Welcome!');
  }
}

class UserService {
  constructor(
    private validator: UserValidator,
    private repository: UserRepository,
    private notifier: UserNotifier,
    private logger: Logger
  ) {}

  createUser(user: User): void {
    this.validator.validate(user);
    this.repository.save(user);
    this.notifier.sendWelcomeEmail(user);
    this.logger.info(`User ${user.id} created`);
  }
}
```

**Benefits:**
- Each class has one clear responsibility
- Easy to test, modify, and reuse
- Changes to email logic don't affect validation or persistence

---

## 2. Open/Closed Principle (OCP)

> Software entities should be open for extension but closed for modification.

Extend behavior without modifying existing code.

### ❌ Bad (Modifying Existing Code)

```typescript
class PaymentProcessor {
  process(type: string, amount: number): void {
    if (type === 'credit-card') {
      // Credit card logic
    } else if (type === 'paypal') {
      // PayPal logic
    } else if (type === 'crypto') {
      // Crypto logic - REQUIRES MODIFYING THIS CLASS
    }
  }
}
```

**Problems:**
- Adding new payment methods requires modifying PaymentProcessor
- Risk of breaking existing functionality
- Violates SRP (handles all payment types)

### ✅ Good (Open for Extension)

```typescript
interface PaymentMethod {
  process(amount: number): void;
}

class CreditCardPayment implements PaymentMethod {
  process(amount: number): void {
    // Credit card logic
  }
}

class PayPalPayment implements PaymentMethod {
  process(amount: number): void {
    // PayPal logic
  }
}

class CryptoPayment implements PaymentMethod {
  process(amount: number): void {
    // Crypto logic - NEW CLASS, NO MODIFICATION
  }
}

class PaymentProcessor {
  process(method: PaymentMethod, amount: number): void {
    method.process(amount);
  }
}
```

**Benefits:**
- Add new payment methods by creating new classes
- Existing code remains untouched and stable
- Easy to test each payment method independently

---

## 3. Liskov Substitution Principle (LSP)

> Subtypes must be substitutable for their base types without altering correctness.

Child classes should enhance, not break, parent class behavior.

### ❌ Bad (Violates LSP)

```typescript
class Bird {
  fly(): void {
    console.log('Flying...');
  }
}

class Penguin extends Bird {
  fly(): void {
    throw new Error('Penguins cannot fly!'); // BREAKS CONTRACT
  }
}

function makeBirdFly(bird: Bird): void {
  bird.fly(); // Will throw error if bird is a Penguin
}
```

**Problems:**
- Penguin cannot be substituted for Bird
- Client code must know implementation details
- Runtime errors instead of compile-time safety

### ✅ Good (Respects LSP)

```typescript
interface Bird {
  eat(): void;
}

interface FlyingBird extends Bird {
  fly(): void;
}

class Sparrow implements FlyingBird {
  eat(): void {
    console.log('Eating seeds...');
  }
  
  fly(): void {
    console.log('Flying...');
  }
}

class Penguin implements Bird {
  eat(): void {
    console.log('Eating fish...');
  }
}

function makeBirdFly(bird: FlyingBird): void {
  bird.fly(); // Only accepts birds that can fly
}
```

**Benefits:**
- Type system enforces correct substitution
- No runtime surprises
- Clear contracts and expectations

---

## 4. Interface Segregation Principle (ISP)

> Clients should not depend on interfaces they don't use.

Create focused interfaces instead of monolithic ones.

### ❌ Bad (Fat Interface)

```typescript
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
  getPaid(): void;
}

class Robot implements Worker {
  work(): void {
    // Works
  }
  
  eat(): void {
    throw new Error('Robots do not eat'); // FORCED TO IMPLEMENT
  }
  
  sleep(): void {
    throw new Error('Robots do not sleep'); // FORCED TO IMPLEMENT
  }
  
  getPaid(): void {
    throw new Error('Robots do not get paid'); // FORCED TO IMPLEMENT
  }
}
```

**Problems:**
- Robot forced to implement irrelevant methods
- Interface too broad and coupled
- Hard to evolve and maintain

### ✅ Good (Segregated Interfaces)

```typescript
interface Workable {
  work(): void;
}

interface Eatable {
  eat(): void;
}

interface Sleepable {
  sleep(): void;
}

interface Payable {
  getPaid(): void;
}

class Human implements Workable, Eatable, Sleepable, Payable {
  work(): void { /* ... */ }
  eat(): void { /* ... */ }
  sleep(): void { /* ... */ }
  getPaid(): void { /* ... */ }
}

class Robot implements Workable {
  work(): void { /* ... */ }
  // Only implements what it needs
}
```

**Benefits:**
- Classes implement only relevant interfaces
- Easy to extend and compose
- Clear separation of concerns

---

## 5. Dependency Inversion Principle (DIP)

> Depend on abstractions, not concretions.

High-level modules should not depend on low-level modules. Both should depend on abstractions.

### ❌ Bad (Depends on Concretions)

```typescript
class MySQLDatabase {
  save(data: string): void {
    console.log('Saving to MySQL:', data);
  }
}

class UserService {
  private db = new MySQLDatabase(); // TIGHTLY COUPLED
  
  saveUser(user: User): void {
    this.db.save(JSON.stringify(user));
  }
}
```

**Problems:**
- UserService tightly coupled to MySQLDatabase
- Cannot switch to PostgreSQL or MongoDB without modifying UserService
- Hard to test (cannot mock database)

### ✅ Good (Depends on Abstractions)

```typescript
interface Database {
  save(data: string): void;
}

class MySQLDatabase implements Database {
  save(data: string): void {
    console.log('Saving to MySQL:', data);
  }
}

class PostgreSQLDatabase implements Database {
  save(data: string): void {
    console.log('Saving to PostgreSQL:', data);
  }
}

class UserService {
  constructor(private db: Database) {} // DEPENDS ON ABSTRACTION
  
  saveUser(user: User): void {
    this.db.save(JSON.stringify(user));
  }
}

// Usage (Dependency Injection)
const userService = new UserService(new MySQLDatabase());
// Or switch to PostgreSQL without changing UserService
const userService2 = new UserService(new PostgreSQLDatabase());
```

**Benefits:**
- Easy to swap implementations
- Testable with mocks
- Loose coupling between modules

---

## Applying SOLID Principles

### Design Checklist

Before writing a class, ask:

- [ ] **SRP:** Does this class have a single, well-defined responsibility?
- [ ] **OCP:** Can I extend this without modifying existing code?
- [ ] **LSP:** Can subclasses be used interchangeably with the parent?
- [ ] **ISP:** Are interfaces focused and not forcing unused methods?
- [ ] **DIP:** Am I depending on abstractions (interfaces) instead of concrete classes?

### Refactoring Workflow

1. **Identify violations** — Look for classes doing too much (SRP)
2. **Extract responsibilities** — Create focused classes/interfaces
3. **Introduce abstractions** — Replace concrete dependencies with interfaces (DIP)
4. **Use composition** — Prefer composition over inheritance (OCP, LSP)
5. **Test in isolation** — Verify each component independently

### Common Code Smells

| Smell | Violated Principle | Fix |
|-------|-------------------|-----|
| God Class (too many responsibilities) | SRP | Extract classes |
| Long if/else or switch statements | OCP | Use polymorphism |
| instanceof checks | LSP | Fix inheritance hierarchy |
| Interfaces with unused methods | ISP | Split interfaces |
| new keyword scattered everywhere | DIP | Use dependency injection |

---

## Language-Specific Examples

### Python

```python
# Dependency Inversion with ABC
from abc import ABC, abstractmethod

class Database(ABC):
    @abstractmethod
    def save(self, data: str) -> None:
        pass

class MySQLDatabase(Database):
    def save(self, data: str) -> None:
        print(f"Saving to MySQL: {data}")

class UserService:
    def __init__(self, db: Database):
        self.db = db
    
    def save_user(self, user: dict) -> None:
        self.db.save(str(user))
```

### Java

```java
// Interface Segregation
public interface Workable {
    void work();
}

public interface Payable {
    void getPaid();
}

public class Employee implements Workable, Payable {
    @Override
    public void work() { /* ... */ }
    
    @Override
    public void getPaid() { /* ... */ }
}

public class Volunteer implements Workable {
    @Override
    public void work() { /* ... */ }
    // No getPaid() - not forced to implement
}
```

---

## Resources

- **Book:** "Clean Architecture" by Robert C. Martin
- **Book:** "Design Patterns" by Gang of Four
- **Article:** [SOLID Principles Explained](https://www.digitalocean.com/community/conceptual_articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design)

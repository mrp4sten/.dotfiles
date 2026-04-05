---
name: clean-code
description: >
  Clean Code principles for readable, maintainable software.
  Trigger: When writing code, refactoring, or reviewing pull requests.
license: Apache-2.0
metadata:
  author: mrp4sten
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Writing new code"
    - "Refactoring existing code"
    - "Code review"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Clean Code Principles

Based on Robert C. Martin's "Clean Code" book, focusing on readability, maintainability, and simplicity.

---

## Meaningful Names

Names should reveal intent, avoid disinformation, and be pronounceable.

### ❌ Bad Names

```typescript
const d = 86400; // What does 'd' mean?
const yyyymmdstr = new Date().toISOString().split('T')[0]; // Unpronounceable
let list = getUsers(); // 'list' is too generic
```

### ✅ Good Names

```typescript
const SECONDS_PER_DAY = 86400;
const currentDateString = new Date().toISOString().split('T')[0];
let activeUsers = getActiveUsers(); // Specific and descriptive
```

### Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| **Variables** | Descriptive noun | `activeUserCount`, `totalPrice` |
| **Functions** | Verb + noun | `calculateTotal()`, `getUserById()` |
| **Classes** | Singular noun | `UserRepository`, `PaymentProcessor` |
| **Constants** | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `API_BASE_URL` |
| **Booleans** | is/has/can prefix | `isActive`, `hasPermission`, `canEdit` |

### Avoid Encodings

```typescript
// ❌ Bad (Hungarian notation)
let strName: string;
let iAge: number;

// ✅ Good (Type system provides type info)
let name: string;
let age: number;
```

---

## Functions

Functions should be small, do one thing, and do it well.

### Small Functions (One Level of Abstraction)

```typescript
// ❌ Bad (Too long, multiple abstraction levels)
function processOrder(order: Order): void {
  // Validate
  if (!order.items || order.items.length === 0) {
    throw new Error('Order must have items');
  }
  
  // Calculate total
  let total = 0;
  for (const item of order.items) {
    total += item.price * item.quantity;
  }
  
  // Apply discount
  if (order.coupon) {
    const discount = total * 0.1;
    total -= discount;
  }
  
  // Save to database
  db.insert('orders', { ...order, total });
  
  // Send email
  emailService.send(order.user.email, 'Order confirmed');
}

// ✅ Good (Small, focused functions)
function processOrder(order: Order): void {
  validateOrder(order);
  const total = calculateTotal(order);
  saveOrder(order, total);
  notifyUser(order);
}

function validateOrder(order: Order): void {
  if (!order.items || order.items.length === 0) {
    throw new Error('Order must have items');
  }
}

function calculateTotal(order: Order): number {
  const subtotal = calculateSubtotal(order.items);
  return applyDiscount(subtotal, order.coupon);
}

function calculateSubtotal(items: OrderItem[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

function applyDiscount(amount: number, coupon?: Coupon): number {
  return coupon ? amount * 0.9 : amount;
}

function saveOrder(order: Order, total: number): void {
  db.insert('orders', { ...order, total });
}

function notifyUser(order: Order): void {
  emailService.send(order.user.email, 'Order confirmed');
}
```

### Function Arguments (Limit to 2-3)

```typescript
// ❌ Bad (Too many arguments)
function createUser(
  name: string,
  email: string,
  age: number,
  address: string,
  phone: string,
  role: string
): User {
  // ...
}

// ✅ Good (Use object parameter)
interface CreateUserDto {
  name: string;
  email: string;
  age: number;
  address: string;
  phone: string;
  role: string;
}

function createUser(dto: CreateUserDto): User {
  // ...
}
```

### Avoid Flag Arguments

```typescript
// ❌ Bad (Boolean flag changes behavior)
function render(isAdmin: boolean): void {
  if (isAdmin) {
    renderAdminDashboard();
  } else {
    renderUserDashboard();
  }
}

// ✅ Good (Separate functions)
function renderAdminDashboard(): void {
  // ...
}

function renderUserDashboard(): void {
  // ...
}
```

---

## Comments

Good code is self-documenting. Use comments sparingly.

### ❌ Bad Comments

```typescript
// Check if user is active
if (user.status === 'active') {
  // ...
}

// Loop through items
for (const item of items) {
  // Process the item
  processItem(item);
}

// This function adds two numbers
function add(a: number, b: number): number {
  return a + b; // Return the sum
}
```

### ✅ Good Comments (When Necessary)

```typescript
// Only use comments for WHY, not WHAT

// WORKAROUND: API returns null instead of empty array (BUG-1234)
const items = response.items || [];

// SECURITY: Hash password with bcrypt (cost factor 12 for ~250ms)
const hashedPassword = await bcrypt.hash(password, 12);

// TODO: Replace with streaming API when available (Q2 2024)
const data = await fetchAllRecords();
```

### Self-Documenting Code

```typescript
// ❌ Bad (Needs comment)
if (user.age >= 18 && user.country === 'US') {
  // User is eligible to vote
  allowVoting(user);
}

// ✅ Good (No comment needed)
const isEligibleToVote = user.age >= 18 && user.country === 'US';
if (isEligibleToVote) {
  allowVoting(user);
}
```

---

## Error Handling

Use exceptions, not error codes. Don't return null.

### ❌ Bad (Error Codes)

```typescript
function getUser(id: string): User | null {
  if (!userExists(id)) {
    return null; // Caller must check for null
  }
  return db.findUser(id);
}

const user = getUser('123');
if (user === null) {
  // Handle error
}
```

### ✅ Good (Exceptions)

```typescript
function getUser(id: string): User {
  if (!userExists(id)) {
    throw new UserNotFoundError(id);
  }
  return db.findUser(id);
}

try {
  const user = getUser('123');
  // Use user (guaranteed to be valid)
} catch (error) {
  if (error instanceof UserNotFoundError) {
    // Handle specific error
  }
}
```

### Don't Return Null

```typescript
// ❌ Bad (Returns null, caller must check)
function getActiveUsers(): User[] | null {
  const users = db.findActiveUsers();
  return users.length > 0 ? users : null;
}

// ✅ Good (Returns empty array)
function getActiveUsers(): User[] {
  return db.findActiveUsers() || [];
}
```

### Extract Try/Catch

```typescript
// ❌ Bad (Business logic mixed with error handling)
function deleteUser(id: string): void {
  try {
    const user = db.findUser(id);
    db.delete(user);
    cache.invalidate(id);
    logger.info(`Deleted user ${id}`);
  } catch (error) {
    logger.error('Failed to delete user', error);
    throw error;
  }
}

// ✅ Good (Separate concerns)
function deleteUser(id: string): void {
  try {
    performDeleteUser(id);
  } catch (error) {
    handleDeleteError(id, error);
  }
}

function performDeleteUser(id: string): void {
  const user = db.findUser(id);
  db.delete(user);
  cache.invalidate(id);
  logger.info(`Deleted user ${id}`);
}

function handleDeleteError(id: string, error: Error): void {
  logger.error(`Failed to delete user ${id}`, error);
  throw error;
}
```

---

## Code Formatting

Consistency matters more than specific style.

### Vertical Formatting

- **Newspaper metaphor:** Most important info at top
- **Blank lines:** Separate concepts
- **Related code:** Keep close together

```typescript
// ✅ Good (Organized vertically)
class UserService {
  // Public API at top
  async createUser(dto: CreateUserDto): Promise<User> {
    this.validateDto(dto);
    const hashedPassword = await this.hashPassword(dto.password);
    return this.repository.save({ ...dto, password: hashedPassword });
  }

  async deleteUser(id: string): Promise<void> {
    await this.repository.delete(id);
    this.cache.invalidate(id);
  }

  // Private helpers below
  private validateDto(dto: CreateUserDto): void {
    if (!dto.email.includes('@')) {
      throw new ValidationError('Invalid email');
    }
  }

  private async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 12);
  }
}
```

### Horizontal Formatting

- **Line length:** Max 80-120 characters
- **Indentation:** 2 or 4 spaces (consistent)
- **Alignment:** Avoid horizontal alignment

```typescript
// ❌ Bad (Horizontal alignment)
const name     = 'John';
const email    = 'john@example.com';
const age      = 30;

// ✅ Good (No alignment)
const name = 'John';
const email = 'john@example.com';
const age = 30;
```

---

## DRY (Don't Repeat Yourself)

Avoid code duplication. Extract common logic.

### ❌ Bad (Duplication)

```typescript
function calculateAdminDiscount(price: number): number {
  const tax = price * 0.1;
  const discount = price * 0.2;
  return price + tax - discount;
}

function calculateUserDiscount(price: number): number {
  const tax = price * 0.1;
  const discount = price * 0.1;
  return price + tax - discount;
}
```

### ✅ Good (Extracted Logic)

```typescript
function calculateFinalPrice(
  price: number,
  discountRate: number
): number {
  const tax = price * 0.1;
  const discount = price * discountRate;
  return price + tax - discount;
}

function calculateAdminDiscount(price: number): number {
  return calculateFinalPrice(price, 0.2);
}

function calculateUserDiscount(price: number): number {
  return calculateFinalPrice(price, 0.1);
}
```

---

## YAGNI (You Aren't Gonna Need It)

Don't add functionality until it's needed.

### ❌ Bad (Premature Abstraction)

```typescript
// Adding flexibility "just in case"
class UserService {
  constructor(
    private db: Database,
    private cache: Cache,
    private logger: Logger,
    private emailService: EmailService,
    private smsService: SmsService, // Not used yet
    private pushService: PushService, // Not used yet
    private analyticsService: AnalyticsService // Not used yet
  ) {}
}
```

### ✅ Good (Add When Needed)

```typescript
// Start simple, extend when required
class UserService {
  constructor(
    private db: Database,
    private cache: Cache,
    private logger: Logger
  ) {}
  
  // Add emailService when email feature is implemented
}
```

---

## Boy Scout Rule

> "Leave the code cleaner than you found it."

Always improve code slightly when touching it.

### Examples

- Rename unclear variable
- Extract magic number to constant
- Split long function
- Add missing type annotation
- Remove unused import

```typescript
// Before (Found)
function calc(x: number): number {
  return x * 1.1 + 50;
}

// After (Cleaned)
const TAX_RATE = 0.1;
const BASE_FEE = 50;

function calculateTotalPrice(price: number): number {
  const tax = price * TAX_RATE;
  return price + tax + BASE_FEE;
}
```

---

## Clean Code Checklist

Before committing code, verify:

- [ ] **Names** — Are they meaningful and pronounceable?
- [ ] **Functions** — Are they small (< 20 lines) and focused?
- [ ] **Arguments** — Max 2-3, use objects if more
- [ ] **Comments** — Only for WHY, not WHAT
- [ ] **Duplication** — DRY principle applied
- [ ] **Error handling** — Exceptions, not null returns
- [ ] **Formatting** — Consistent style
- [ ] **Tests** — Code is testable and tested
- [ ] **Boy Scout** — Code is cleaner than before

---

## Resources

- **Book:** "Clean Code" by Robert C. Martin
- **Book:** "The Pragmatic Programmer" by Hunt & Thomas
- **Tool:** ESLint, Prettier, SonarQube (automated checks)

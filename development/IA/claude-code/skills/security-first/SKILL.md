---
name: security-first
description: >
  Security-first development practices (Shift-Left Security).
  Trigger: When handling user input, authentication, data storage, or API design.
license: Apache-2.0
metadata:
  author: mrp4sten
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Handling user input or authentication"
    - "Storing sensitive data"
    - "Designing APIs or endpoints"
    - "Working with external dependencies"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Security-First Development

Security is not a feature — it's a requirement. Apply security principles from day one (Shift-Left Security).

---

## OWASP Top 10 (2021)

The most critical web application security risks:

1. **Broken Access Control**
2. **Cryptographic Failures**
3. **Injection**
4. **Insecure Design**
5. **Security Misconfiguration**
6. **Vulnerable and Outdated Components**
7. **Identification and Authentication Failures**
8. **Software and Data Integrity Failures**
9. **Security Logging and Monitoring Failures**
10. **Server-Side Request Forgery (SSRF)**

---

## 1. Input Validation (Defense Against Injection)

**Never trust user input.** Always validate, sanitize, and escape.

### SQL Injection Prevention

```typescript
// ❌ CRITICAL VULNERABILITY (SQL Injection)
const query = `SELECT * FROM users WHERE email = '${userInput}'`;
db.execute(query);
// Attacker input: ' OR '1'='1' --
// Result: SELECT * FROM users WHERE email = '' OR '1'='1' --'

// ✅ SECURE (Parameterized Query)
const query = 'SELECT * FROM users WHERE email = ?';
db.execute(query, [userInput]);
```

### XSS Prevention

```typescript
// ❌ CRITICAL VULNERABILITY (XSS)
document.innerHTML = userInput;
// Attacker input: <script>steal(document.cookie)</script>

// ✅ SECURE (Escape HTML)
import DOMPurify from 'dompurify';
document.innerHTML = DOMPurify.sanitize(userInput);

// Or use textContent (no HTML rendering)
document.textContent = userInput;
```

### Command Injection Prevention

```bash
# ❌ CRITICAL VULNERABILITY (Command Injection)
filename="$USER_INPUT"
cat "$filename"
# Attacker input: file.txt; rm -rf /

# ✅ SECURE (Validate input)
if [[ "$USER_INPUT" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    cat "$USER_INPUT"
else
    echo "Invalid filename"
    exit 1
fi
```

### Input Validation Rules

```typescript
import { z } from 'zod';

// Define strict schemas
const CreateUserSchema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(12).max(128),
  age: z.number().int().min(0).max(150),
  role: z.enum(['user', 'admin']), // Whitelist, not blacklist
});

// Validate before processing
function createUser(input: unknown): User {
  const data = CreateUserSchema.parse(input); // Throws if invalid
  // Proceed with validated data
}
```

---

## 2. Authentication & Authorization

### Password Storage (NEVER Plain Text)

```typescript
import bcrypt from 'bcrypt';

// ❌ CRITICAL VULNERABILITY (Plain text password)
db.insert('users', { email, password }); // NEVER DO THIS

// ❌ BAD (Weak hashing)
import crypto from 'crypto';
const hash = crypto.createHash('md5').update(password).digest('hex'); // MD5 is broken

// ✅ SECURE (bcrypt with high cost factor)
const SALT_ROUNDS = 12; // ~250ms to hash (adjust based on threat model)
const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);
db.insert('users', { email, password: hashedPassword });

// Verification
const isValid = await bcrypt.compare(inputPassword, storedHash);
```

### JWT Security

```typescript
import jwt from 'jsonwebtoken';

// ❌ BAD (Weak secret, no expiration)
const token = jwt.sign({ userId }, 'secret123');

// ✅ SECURE (Strong secret, expiration, algorithm specified)
const secret = process.env.JWT_SECRET; // 256-bit random string
if (!secret || secret.length < 32) {
  throw new Error('JWT_SECRET must be at least 256 bits');
}

const token = jwt.sign(
  { userId },
  secret,
  {
    algorithm: 'HS256',
    expiresIn: '15m', // Short-lived access token
    issuer: 'my-app',
    audience: 'api.myapp.com',
  }
);

// Verification
try {
  const payload = jwt.verify(token, secret, {
    algorithms: ['HS256'], // Prevent algorithm confusion
    issuer: 'my-app',
    audience: 'api.myapp.com',
  });
} catch (error) {
  throw new UnauthorizedError('Invalid token');
}
```

### Authorization (Access Control)

```typescript
// ❌ BAD (Trusting client-provided role)
function deleteUser(req: Request): void {
  if (req.body.isAdmin) { // ATTACKER CONTROLS THIS
    db.deleteUser(req.params.id);
  }
}

// ✅ SECURE (Server-side verification)
function deleteUser(req: Request): void {
  const currentUser = getUserFromToken(req.headers.authorization);
  
  if (!currentUser.hasRole('admin')) {
    throw new ForbiddenError('Admin access required');
  }
  
  // Additional check: users can only delete themselves, admins can delete anyone
  const targetUserId = req.params.id;
  if (currentUser.role !== 'admin' && currentUser.id !== targetUserId) {
    throw new ForbiddenError('Cannot delete other users');
  }
  
  db.deleteUser(targetUserId);
}
```

---

## 3. Secrets Management

### ❌ NEVER Hardcode Secrets

```typescript
// ❌ CRITICAL VULNERABILITY
const apiKey = 'sk_live_abc123xyz'; // NEVER IN CODE
const dbPassword = 'mypassword123'; // NEVER IN CODE

// ❌ BAD (Committed to Git)
// .env file committed to repository

// ✅ SECURE (Environment variables, never committed)
const apiKey = process.env.API_KEY;
const dbPassword = process.env.DB_PASSWORD;

if (!apiKey || !dbPassword) {
  throw new Error('Missing required environment variables');
}

// .gitignore should include:
// .env
// .env.local
// secrets/
```

### Secrets Rotation

```typescript
// Support multiple API keys for zero-downtime rotation
const API_KEYS = [
  process.env.API_KEY_CURRENT,
  process.env.API_KEY_PREVIOUS, // Keep old key during transition
].filter(Boolean);

function validateApiKey(key: string): boolean {
  return API_KEYS.includes(key);
}
```

---

## 4. Cryptography

### HTTPS Only (No Exceptions)

```typescript
// ❌ BAD (HTTP allowed)
app.listen(3000);

// ✅ SECURE (HTTPS enforced)
import https from 'https';
import fs from 'fs';

const options = {
  key: fs.readFileSync('private-key.pem'),
  cert: fs.readFileSync('certificate.pem'),
};

https.createServer(options, app).listen(443);

// Redirect HTTP to HTTPS
import http from 'http';
http.createServer((req, res) => {
  res.writeHead(301, { Location: `https://${req.headers.host}${req.url}` });
  res.end();
}).listen(80);
```

### Encryption at Rest

```typescript
import crypto from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const KEY = Buffer.from(process.env.ENCRYPTION_KEY, 'hex'); // 32 bytes

function encrypt(plaintext: string): string {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(ALGORITHM, KEY, iv);
  
  let encrypted = cipher.update(plaintext, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  
  const authTag = cipher.getAuthTag();
  
  // Return iv:authTag:ciphertext
  return `${iv.toString('hex')}:${authTag.toString('hex')}:${encrypted}`;
}

function decrypt(ciphertext: string): string {
  const [ivHex, authTagHex, encrypted] = ciphertext.split(':');
  
  const iv = Buffer.from(ivHex, 'hex');
  const authTag = Buffer.from(authTagHex, 'hex');
  
  const decipher = crypto.createDecipheriv(ALGORITHM, KEY, iv);
  decipher.setAuthTag(authTag);
  
  let decrypted = decipher.update(encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  
  return decrypted;
}
```

---

## 5. Rate Limiting & DoS Prevention

```typescript
import rateLimit from 'express-rate-limit';

// ✅ SECURE (Rate limiting)
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per window
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/', limiter);

// Stricter limits for sensitive endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // Only 5 login attempts per 15 minutes
  skipSuccessfulRequests: true,
});

app.post('/api/login', authLimiter, loginHandler);
```

---

## 6. CORS (Cross-Origin Resource Sharing)

```typescript
import cors from 'cors';

// ❌ BAD (Allow all origins)
app.use(cors({ origin: '*' }));

// ✅ SECURE (Whitelist specific origins)
const ALLOWED_ORIGINS = [
  'https://app.example.com',
  'https://admin.example.com',
];

app.use(cors({
  origin: (origin, callback) => {
    if (!origin || ALLOWED_ORIGINS.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true, // Allow cookies
  maxAge: 86400, // Cache preflight for 24 hours
}));
```

---

## 7. Dependency Security

### Keep Dependencies Updated

```bash
# Check for vulnerabilities
npm audit
yarn audit
pnpm audit

# Fix automatically (review changes!)
npm audit fix

# Update dependencies
npm update
```

### Lock File Integrity

```bash
# Always commit lock files
git add package-lock.json  # npm
git add yarn.lock          # yarn
git add pnpm-lock.yaml     # pnpm

# Verify integrity before install
npm ci  # Uses package-lock.json exactly
```

### Minimize Dependencies

```typescript
// ❌ BAD (Unnecessary dependencies)
import _ from 'lodash'; // Entire library for one function

// ✅ GOOD (Native alternatives or specific imports)
import { debounce } from 'lodash-es/debounce'; // Tree-shakeable
// Or use native: array.filter(), array.map(), etc.
```

---

## 8. Security Headers

```typescript
import helmet from 'helmet';

// ✅ SECURE (Security headers)
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"], // Avoid unsafe-inline in production
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", 'data:', 'https:'],
    },
  },
  hsts: {
    maxAge: 31536000, // 1 year
    includeSubDomains: true,
    preload: true,
  },
}));

// Additional headers
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  next();
});
```

---

## 9. Logging & Monitoring

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ],
});

// ❌ BAD (Logging sensitive data)
logger.info('User login', { email, password }); // NEVER LOG PASSWORDS

// ✅ SECURE (Redact sensitive data)
logger.info('User login attempt', {
  email,
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  timestamp: new Date().toISOString(),
});

// Log security events
logger.warn('Failed login attempt', { email, ip, attempts: 3 });
logger.error('Suspicious activity detected', { userId, action });
```

---

## Security Checklist

Before deploying:

- [ ] **Input validation** — All user input validated with strict schemas
- [ ] **Authentication** — Passwords hashed with bcrypt (cost 12+)
- [ ] **Authorization** — Access control verified server-side
- [ ] **Secrets** — No hardcoded secrets, using env vars
- [ ] **HTTPS** — Enforced, HTTP redirects to HTTPS
- [ ] **CORS** — Whitelist specific origins
- [ ] **Rate limiting** — Enabled on all endpoints
- [ ] **Security headers** — Helmet configured
- [ ] **Dependencies** — npm audit passed, dependencies updated
- [ ] **Logging** — Security events logged (no sensitive data)
- [ ] **Error messages** — Generic messages (no stack traces in production)

---

## Resources

- **OWASP Top 10:** https://owasp.org/www-project-top-ten/
- **OWASP Cheat Sheets:** https://cheatsheetseries.owasp.org/
- **Tool:** Snyk, npm audit, OWASP ZAP
- **Book:** "The Web Application Hacker's Handbook"

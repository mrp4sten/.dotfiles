---
name: security-audit
description: Review code or configuration for security vulnerabilities. Use when the user asks to audit security, check for vulnerabilities, review auth logic, or validate input handling.
---

## Security Audit Process

### OWASP Top 10 Checklist

**Injection (SQL, Command, LDAP)**
- Are all inputs parameterized or properly escaped?
- Is user input ever concatenated into a query or shell command?

**Broken Authentication**
- Are passwords hashed with a strong algorithm (bcrypt, argon2)?
- Are session tokens random, sufficiently long, and invalidated on logout?
- Is there rate limiting on login/auth endpoints?

**Sensitive Data Exposure**
- Is sensitive data encrypted at rest and in transit?
- Are secrets in env vars, never in code or logs?
- Is PII minimized — only collected if needed?

**Broken Access Control**
- Is authorization checked on every protected endpoint?
- Are object-level permissions enforced (user can only access their own data)?
- Are admin/internal routes protected from regular users?

**Security Misconfiguration**
- Are default credentials changed?
- Are debug modes/stack traces disabled in production?
- Are unnecessary services/ports exposed?

**XSS (for web)**
- Is user-generated content escaped before rendering?
- Is Content-Security-Policy set?

**Insecure Dependencies**
- Are dependencies up to date?
- Any known CVEs in the dependency tree?

### Output Format
For each finding:
- **Severity**: Critical / High / Medium / Low / Informational
- **Location**: file, function, line if known
- **Issue**: what the vulnerability is
- **Risk**: what an attacker could do with it
- **Remediation**: concrete fix
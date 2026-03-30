# Multi-tenancy

Isolating data between tenants (organizations/teams) in your SaaS.

## Isolation strategies

| Strategy | How it works | Best for |
|----------|-------------|----------|
| **Row-level** | All tenants share tables, every query filters by `tenant_id` | Most SaaS, simplest |
| **Schema-level** | Each tenant gets its own database schema | Compliance-heavy, moderate scale |
| **Database-level** | Each tenant gets its own database | Enterprise, maximum isolation |

**Start with row-level.** It covers 90% of SaaS products. Only move to schema/database isolation
when a specific compliance or performance requirement demands it.

## Row-level isolation

### Every table gets a `tenant_id`

```sql
CREATE TABLE projects (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_projects_tenant ON projects(tenant_id);
```

### Every query filters by tenant

```javascript
// WRONG — leaks data across tenants
const projects = db.query('SELECT * FROM projects')

// RIGHT — scoped to current tenant
const projects = db.query('SELECT * FROM projects WHERE tenant_id = ?', [tenantId])
```

### Middleware pattern

Extract the tenant from the authenticated user and inject it into every request:

```javascript
function tenantMiddleware(req, res, next) {
  req.tenantId = req.user.tenantId
  if (!req.tenantId) return res.status(403).json({ error: 'No tenant' })
  next()
}
```

## Testing tenant isolation

Write tests that verify:
- [ ] User A cannot see User B's data
- [ ] API endpoints return 403/404 for cross-tenant access
- [ ] List endpoints only return current tenant's records
- [ ] Bulk operations are scoped to the current tenant
- [ ] Admin endpoints still enforce tenant boundaries

## Tenant onboarding

When a new tenant signs up:
1. Create tenant record
2. Create owner user linked to tenant
3. Seed default data (settings, roles) if needed
4. Send welcome email

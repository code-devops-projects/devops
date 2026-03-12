# Contributing to Liquibase Database Repository

Thank you for your interest in contributing to this database repository! This document provides guidelines and best practices for contributing.

## Table of Contents
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Changeset Guidelines](#changeset-guidelines)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Code Review](#code-review)

## Getting Started

1. **Fork the repository** (if external contributor)
2. **Clone your fork**:
   ```bash
   git clone <your-fork-url>
   cd <repo-name>
   ```
3. **Set up your local environment**:
   ```bash
   docker-compose up -d
   liquibase validate
   ```

## Development Workflow

### Branch Naming Convention

Use descriptive branch names following this pattern:
```
<type>/<ticket-number>-<short-description>

Examples:
- feature/TICKET-123-add-user-table
- fix/TICKET-456-update-index
- hotfix/TICKET-789-rollback-error
```

### Types
- `feature/` - New database features (tables, procedures, etc.)
- `fix/` - Bug fixes
- `hotfix/` - Critical production fixes
- `refactor/` - Code refactoring without functional changes
- `docs/` - Documentation updates

### Workflow Steps

1. **Create a new branch**:
   ```bash
   git checkout -b feature/TICKET-123-add-user-table
   ```

2. **Make your changes**:
   - Create SQL file in appropriate folder
   - Add changeset to corresponding `00000_changelog.yaml`
   - Create rollback script (if needed)

3. **Test locally**:
   ```bash
   liquibase validate
   liquibase status
   liquibase update
   liquibase rollback-count 1  # Test rollback
   liquibase update  # Re-apply
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat(db): add user table for authentication"
   ```

5. **Push to remote**:
   ```bash
   git push origin feature/TICKET-123-add-user-table
   ```

6. **Create Pull Request**

## Coding Standards

### SQL File Standards

1. **File Header**: Always include a complete header
   ```sql
   --==========================================================================================
   --| Author: Your Name                                                                      |
   --| Name: object_name                                                                      |
   --| Description: Brief description                                                         |
   --|                                                                                        |
   --| Create date: YYYY-MM-DD                                                                |
   --| Ticket: TICKET-123                                                                     |
   --==========================================================================================
   ```

2. **Formatting**:
   - Use uppercase for SQL keywords: `SELECT`, `FROM`, `WHERE`
   - Use lowercase for identifiers: `table_name`, `column_name`
   - Indent nested queries by 4 spaces
   - One statement per line for complex queries

3. **Naming Conventions**:
   - Tables: `{module}_{type}_{name}` (e.g., `user_tb_accounts`)
   - Procedures: `p_{action}_{entity}` (e.g., `p_get_user_by_id`)
   - Functions: `f_{action}_{entity}` (e.g., `f_calculate_total`)
   - Views: `v_{name}` (e.g., `v_active_users`)
   - Materialized Views: `mv_{name}` (e.g., `mv_user_summary`)
   - Triggers: `tr_{action}_{table}` (e.g., `tr_update_timestamp`)
   - Indexes: `idx_{table}_{columns}` (e.g., `idx_users_email`)

4. **Comments**:
   - Add comments for complex logic
   - Use `COMMENT ON` statements for schema documentation
   ```sql
   COMMENT ON TABLE users IS 'Stores user authentication information';
   COMMENT ON COLUMN users.email IS 'User email address (unique)';
   ```

### Changeset Standards

1. **ID Format**: Use UUID v4 format
   ```yaml
   id: a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d
   ```
   Generate UUIDs using:
   ```bash
   # PowerShell
   [guid]::NewGuid()
   
   # Linux/Mac
   uuidgen
   ```

2. **Required Fields**:
   ```yaml
   - changeSet:
       id: a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d
       author: your.email@company.com
       context: myproject
       labels: TICKET-123
       comment: Brief description of change
       changes:
         - tagDatabase:
             tag: v1.0.0
         - sqlFile:
             path: 01_tables\00001_example.sql
             endDelimiter: \nGO
             stripComments: false
   ```

3. **Versioning**: Follow semantic versioning
   - Patch: `v1.0.0` → `v1.0.1` (bug fixes)
   - Minor: `v1.0.0` → `v1.1.0` (new features)
   - Major: `v1.0.0` → `v2.0.0` (breaking changes)

## Changeset Guidelines

### Do's ✅

- **Create new changesets** for all changes
- **Test locally** before pushing
- **Include rollback scripts** for destructive changes
- **Use descriptive comments**
- **Document dependencies** in changeset comments
- **Keep changes atomic** (one logical change per changeset)
- **Use preconditions** when appropriate
- **Follow naming conventions**

### Don'ts ❌

- **Never modify executed changesets**
- **Don't commit credentials** to repository
- **Don't skip testing** before pushing
- **Don't combine unrelated changes**
- **Don't use `DROP` without backups**
- **Don't forget rollback scripts**
- **Don't use hardcoded values** (use parameters)

## Testing

### Local Testing Checklist

Before pushing changes:

- [ ] `liquibase validate` passes
- [ ] `liquibase status` shows expected changesets
- [ ] `liquibase update` executes successfully
- [ ] Rollback script exists (if needed)
- [ ] `liquibase rollback-count 1` works correctly
- [ ] Re-apply works: `liquibase update`
- [ ] SQL syntax is correct
- [ ] No credentials in files
- [ ] All files follow naming conventions

### Testing Commands

```bash
# Validate changelog
liquibase validate

# Check pending changes
liquibase status

# Preview SQL (dry run)
liquibase update-sql > preview.sql

# Apply changes
liquibase update

# Test rollback
liquibase rollback-count 1

# Re-apply
liquibase update

# Test complete update-rollback cycle
liquibase update-testing-rollback
```

## Pull Request Process

### Before Creating PR

1. ✅ All tests pass locally
2. ✅ Code follows style guidelines
3. ✅ Documentation is updated
4. ✅ Changeset includes proper metadata
5. ✅ Rollback scripts are included
6. ✅ No sensitive data in commits

### PR Title Format

Use conventional commits format:
```
<type>(<scope>): <short description>

Examples:
- feat(tables): add user authentication table
- fix(procedures): correct user lookup procedure
- docs(readme): update deployment instructions
```

### PR Description Template

```markdown
## Description
Brief description of the changes

## Related Ticket
TICKET-123

## Type of Change
- [ ] New feature (tables, procedures, etc.)
- [ ] Bug fix
- [ ] Breaking change
- [ ] Documentation update

## Changeset Details
- **Tag**: v1.2.0
- **Files Modified**: 
  - 01_tables/00042_user_table.sql
  - 01_tables/00000_changelog.yaml
  - 11_rollbacks/01_tables/00042_user_table_rollback.sql

## Testing
- [x] Validated locally with `liquibase validate`
- [x] Tested with `liquibase update`
- [x] Tested rollback with `liquibase rollback-count 1`
- [x] Re-applied successfully

## Checklist
- [x] Code follows style guidelines
- [x] Added/updated documentation
- [x] Added rollback scripts
- [x] No credentials in code
- [x] Changeset follows naming convention

## Screenshots (if applicable)
Add screenshots of database changes or query results
```

## Code Review

### Reviewer Checklist

When reviewing PRs:

- [ ] Changeset ID is unique UUID (v4 format)
- [ ] SQL syntax is correct
- [ ] Proper indexing is considered
- [ ] Foreign keys and constraints are appropriate
- [ ] Rollback script exists and is correct
- [ ] No hardcoded credentials
- [ ] Comments and documentation are clear
- [ ] Follows naming conventions
- [ ] Testing evidence is provided
- [ ] Version tag is appropriate

### Review Process

1. **Check changeset structure** - Validate YAML syntax
2. **Review SQL code** - Check for best practices
3. **Verify rollback** - Ensure proper rollback strategy
4. **Test locally** - Pull and test the changes
5. **Approve or request changes**

## Questions or Issues?

- Check the [README.md](README.md)
- Review [QUICKSTART.md](QUICKSTART.md)
- Ask in team chat or create an issue

## Thank You!

Your contributions help maintain a robust and reliable database schema. Thank you for following these guidelines!

# Liquibase Database Repository Template

This repository template provides a complete structure for managing database schema evolution and version control using Liquibase. It follows best practices for organizing database changes across multiple environments.

## Table of Contents
- [About Liquibase](#about-liquibase)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Changeset Guidelines](#changeset-guidelines)
- [Deployment Process](#deployment-process)
- [CI/CD Pipeline](#cicd-pipeline)
- [Environment Variables](#environment-variables)
- [Best Practices](#best-practices)
- [Rollback Strategy](#rollback-strategy)
- [Common Commands](#common-commands)

## About Liquibase

Liquibase is an open-source database schema change management solution that enables you to:
- Track, version, and deploy database changes
- Automate database updates across different environments
- Roll back changes when needed
- Generate database documentation
- Maintain database change history

### Resources
- [Liquibase Documentation](https://docs.liquibase.com/start/home.html)
- [YAML Format Changelogs](https://docs.liquibase.com/concepts/changelogs/yaml-format.html)
- [Liquibase Best Practices](https://docs.liquibase.com/concepts/bestpractices.html)

## Repository Structure

```text
├── 01_tables/                              # Database tables (CREATE TABLE, ALTER TABLE)
│   ├── .gitkeep
│   ├── 00000_changelog.yaml                # Master changelog for tables
│   ├── 00001_example_table.sql             # Example table creation
│   └── ...
├── 02_procedures/                          # Stored procedures
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 03_materialized_views/                  # Materialized views
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 04_functions/                           # Database functions
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 05_views/                               # Database views
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 06_triggers/                            # Database triggers
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 07_indexes/                             # Database indexes
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 08_types/                               # Custom types
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 09_inserts/                             # Data inserts and seeds
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 10_updates/                             # Data updates
│   ├── .gitkeep
│   ├── 00000_changelog.yaml
│   └── ...
├── 11_rollbacks/                           # Rollback scripts
│   ├── 01_tables/
│   ├── 02_procedures/
│   ├── 09_inserts/
│   ├── 10_updates/
│   └── ...
├── .gitignore                              # Git ignore rules
├── .gitlab-ci.yml                          # CI/CD pipeline configuration
├── changelog.yaml                          # Master changelog file
├── docker-compose.yml                      # Docker PostgreSQL setup
├── liquibase.properties                    # Liquibase configuration
├── postgresql-42.3.0.jar                   # PostgreSQL JDBC driver
└── README.md                               # This file
```

## Getting Started

### Prerequisites

1. **Liquibase**: Install Liquibase CLI
   ```bash
   # macOS (Homebrew)
   brew install liquibase
   
   # Windows (Chocolatey)
   choco install liquibase
   
   # Linux
   wget https://github.com/liquibase/liquibase/releases/download/v4.28.0/liquibase-4.28.0.tar.gz
   tar -xzf liquibase-4.28.0.tar.gz
   ```

2. **PostgreSQL JDBC Driver**: Download if not included
   ```bash
   wget https://jdbc.postgresql.org/download/postgresql-42.3.0.jar
   ```

3. **Docker** (optional, for local database):
   ```bash
   docker-compose up -d
   ```

### Configuration

1. **Update `liquibase.properties`**:
   ```properties
   liquibase.command.url=jdbc:postgresql://localhost:5432/your-database-name
   liquibase.command.username: your-username
   liquibase.command.password: your-password
   ```

2. **Update `docker-compose.yml`** (if using Docker):
   ```yaml
   environment:
     - POSTGRES_USER=your-username
     - POSTGRES_PASSWORD=your-password
     - POSTGRES_DB=your-database-name
   ```

## Changeset Guidelines

### Naming Convention

Files should follow this pattern:
```
{sequence_number}_{descriptive_name}.sql
```

Examples:
- `00001_create_users_table.sql`
- `00002_add_email_column_to_users.sql`
- `00003_create_orders_table.sql`

### Changeset Template

Add this structure to the appropriate `00000_changelog.yaml` file:

```yaml
- changeSet:
    id: 00001_project_name
    author: your.email@company.com
    context: project_name
    labels: TICKET-001
    comment: Brief description of the change
    changes:
      - tagDatabase:
          tag: v1.0.0
      - sqlFile:
          path: 01_tables\00001_example_table.sql
          endDelimiter: \nGO
          stripComments: false
    rollback:
      - sqlFile:
          path: 11_rollbacks\01_tables\00001_example_table_rollback.sql
```

### Versioning Strategy

Follow **Semantic Versioning** for tags:
- **Patch** (v1.0.0 → v1.0.1): Bug fixes, minor changes
- **Minor** (v1.0.0 → v1.1.0): New features, backward compatible
- **Major** (v1.0.0 → v2.0.0): Breaking changes

### SQL File Template

```sql
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: table_or_object_name                                                             |
--| Description: Brief description of what this script does                                |
--|                                                                                        |
--| Create date: YYYY-MM-DD                                                                |
--| Ticket: TICKET-001                                                                     |
--|                                                                                        |
--| =======================================================================================|
--| Change History:                                                                        |
--| =======================================================================================|
--| Date        | Ticket      | Author            | Description                          |
--|========================================================================================|
--| YYYY-MM-DD  | TICKET-001  | Your Name         | Initial creation                     |
--==========================================================================================

-- Your SQL code here
CREATE TABLE IF NOT EXISTS example_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

GO
```

## Deployment Process

### Local Development

1. **Validate changes**:
   ```bash
   liquibase validate
   ```

2. **Check status** (list undeployed changesets):
   ```bash
   liquibase status
   ```

3. **Apply changes**:
   ```bash
   liquibase update
   ```

4. **Rollback** (if needed):
   ```bash
   liquibase rollback-count 1
   # or
   liquibase rollback-to-tag v1.0.0
   ```

### Branching Strategy

This repository follows a **four-branch deployment model**:

- **`develop`**: Development environment (auto-deploy on push)
- **`qa`**: QA/Testing environment (manual deploy)
- **`staging`**: Staging/Pre-production (manual deploy)
- **`main`**: Production environment (manual deploy, requires approval)

## CI/CD Pipeline

The `.gitlab-ci.yml` file defines three stages:

### 1. job_validate
Validates the changelog file to detect syntax errors or issues.

```bash
liquibase --changeLogFile=changelog.yaml validate
```

### 2. job_status
Lists all undeployed changesets with ID, author, and file path.

```bash
liquibase --changeLogFile=changelog.yaml status
```

### 3. job_update
Applies all pending changesets to the database.

```bash
liquibase --changeLogFile=changelog.yaml update
```

**Note**: The `job_update` stage requires manual approval for `staging` and `main` branches.

## Environment Variables

Configure these variables in your GitLab CI/CD settings:

### Development Environment
- `DB_PORT_DEV` - Database port (e.g., `5432`)
- `DB_HOST_DEV` - Database host (e.g., `dev-db.example.com`)
- `DB_NAME_DEV` - Database name
- `DB_USER_DEV` - Database username
- `DB_PASSWORD_DEV` - Database password

### QA Environment
- `DB_PORT_QA`
- `DB_HOST_QA`
- `DB_NAME_QA`
- `DB_USER_QA`
- `DB_PASSWORD_QA`

### Staging Environment
- `DB_PORT_STAGING`
- `DB_HOST_STAGING`
- `DB_NAME_STAGING`
- `DB_USER_STAGING`
- `DB_PASSWORD_STAGING`

### Production Environment
- `DB_PORT_PROD`
- `DB_HOST_PROD`
- `DB_NAME_PROD`
- `DB_USER_PROD`
- `DB_PASSWORD_PROD`

## Best Practices

### 1. Never Modify Executed Changesets
Once a changeset has been deployed, **never modify it**. Always create a new changeset for additional changes.

### 1. **Use Unique UUIDs for IDs**
Changeset IDs should be unique UUIDs to avoid conflicts:
```yaml
id: a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d
```
You can generate UUIDs using online tools or commands:
```bash
# PowerShell
[guid]::NewGuid()

# Linux/Mac
uuidgen
```

### 3. Include Rollback Scripts
Always provide rollback scripts for destructive or complex changes:
```yaml
rollback:
  - sqlFile:
      path: 11_rollbacks\01_tables\00001_example_rollback.sql
```

### 4. Test Locally First
Before pushing changes:
```bash
liquibase validate
liquibase status
liquibase update-testing-rollback
```

### 5. Keep SQL Files Focused
Each SQL file should handle **one logical change**. Avoid combining unrelated changes.

### 6. Use Contexts and Labels
Organize changesets with contexts (e.g., `dev`, `test`, `prod`) and labels (e.g., ticket numbers):
```yaml
context: production
labels: TICKET-1234
```

### 7. Document Your Changes
Add meaningful comments to each changeset:
```yaml
comment: Add email index to improve query performance on users table
```

### 8. Order Matters
Changesets are executed in the order they appear. Ensure dependencies are respected.

## Rollback Strategy

### Creating Rollback Scripts

For each destructive changeset, create a corresponding rollback script:

**Example**: If `00001_create_users_table.sql` creates a table:

```sql
-- 11_rollbacks/01_tables/00001_create_users_table_rollback.sql
DROP TABLE IF EXISTS users CASCADE;
GO
```

### Executing Rollbacks

```bash
# Rollback last changeset
liquibase rollback-count 1

# Rollback to a specific tag
liquibase rollback-to-tag v1.0.0

# Rollback to a specific date
liquibase rollback-to-date "2024-01-01"
```

## Common Commands

```bash
# Validate changelog syntax
liquibase validate

# Show undeployed changesets
liquibase status

# Apply all pending changes
liquibase update

# Show SQL that will be executed (without applying)
liquibase update-sql

# Rollback last N changesets
liquibase rollback-count N

# Rollback to a tag
liquibase rollback-to-tag <tag-name>

# Generate changelog from existing database
liquibase generate-changelog

# Mark all changesets as executed (without running them)
liquibase changelog-sync

# Clear checksums (use cautiously)
liquibase clear-checksums

# Get database info
liquibase db-doc <output-directory>

# Diff between two databases
liquibase diff \
  --referenceUrl=jdbc:postgresql://localhost:5432/reference_db \
  --referenceUsername=user \
  --referencePassword=pass
```

## Troubleshooting

### Checksum Validation Failed

If you see checksum errors:
```bash
liquibase clear-checksums
liquibase update
```

### Lock Issues

If the database is locked:
```bash
liquibase release-locks
```

### Connection Issues

Verify your connection:
```bash
liquibase --url=jdbc:postgresql://host:port/dbname \
  --username=user \
  --password=pass \
  status
```

## Additional Resources

- [Liquibase Official Documentation](https://docs.liquibase.com/)
- [Liquibase Community Forum](https://forum.liquibase.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)

## Support

For questions or issues:
1. Check the [Liquibase Documentation](https://docs.liquibase.com/)
2. Review existing changesets in this repository
3. Contact your team lead or database administrator

## License

MIT License - see the [LICENSE](LICENSE) file for details.

---

**Last Updated**: 2025-11-11
**Author**: Jesús Ariel González Bonilla

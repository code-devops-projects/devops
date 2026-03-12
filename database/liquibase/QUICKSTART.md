# Liquibase Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Clone/Copy this Repository
```bash
git clone <your-repo-url>
cd <your-repo-name>
```

### Step 2: Install Prerequisites
- **Liquibase**: [Download](https://www.liquibase.org/download)
- **PostgreSQL JDBC Driver**: Already included (`postgresql-42.3.0.jar`)
- **Docker** (optional): For local database

### Step 3: Configure Your Database
Edit `liquibase.properties`:
```properties
liquibase.command.url=jdbc:postgresql://localhost:5432/your-database-name
liquibase.command.username: your-username
liquibase.command.password: your-password
```

### Step 4: Start Local Database (Optional)
```bash
docker-compose up -d
```

### Step 5: Run Your First Migration
```bash
# Validate your changelog
liquibase validate

# Check what will be deployed
liquibase status

# Deploy changes
liquibase update
```

## 📝 Creating Your First Changeset

### 1. Create SQL File
Create a new file in the appropriate folder (e.g., `01_tables/00003_my_new_table.sql`):

```sql
--==========================================================================================
--| Author: Your Name                                                                      |
--| Name: my_new_table                                                                     |
--| Description: Description of your table                                                 |
--|                                                                                        |
--| Create date: 2025-11-11                                                                |
--| Ticket: TICKET-123                                                                     |
--==========================================================================================

CREATE TABLE IF NOT EXISTS my_new_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

GO
```

### 2. Add Changeset to Changelog
Edit `01_tables/00000_changelog.yaml`:

```yaml
- changeSet:
    id: f2a3b4c5-d6e7-4f8a-9b0c-1d2e3f4a5b6c
    author: your.email@company.com
    context: project_name
    labels: TICKET-123
    comment: Create my_new_table
    changes:
      - tagDatabase:
          tag: v1.0.2
      - sqlFile:
          path: 01_tables\00003_my_new_table.sql
          endDelimiter: \nGO
          stripComments: false
```

### 3. Test Locally
```bash
liquibase validate
liquibase status
liquibase update
```

### 4. Commit and Push
```bash
git add .
git commit -m "feat(db): create my_new_table"
git push origin develop
```

## 🔄 Common Workflows

### Add a New Table
1. Create SQL file in `01_tables/`
2. Add changeset to `01_tables/00000_changelog.yaml`
3. Create rollback in `11_rollbacks/01_tables/` (if needed)
4. Test with `liquibase update`

### Add a New Stored Procedure
1. Create SQL file in `02_procedures/`
2. Add changeset to `02_procedures/00000_changelog.yaml`
3. Test with `liquibase update`

### Insert Initial Data
1. Create SQL file in `09_inserts/`
2. Add changeset to `09_inserts/00000_changelog.yaml`
3. Create rollback in `11_rollbacks/09_inserts/`
4. Test with `liquibase update`

### Update Existing Data
1. Create SQL file in `10_updates/`
2. Add changeset to `10_updates/00000_changelog.yaml`
3. Create rollback in `11_rollbacks/10_updates/`
4. Test with `liquibase update`

## 🛠️ Essential Commands

```bash
# Validate changelog
liquibase validate

# Show pending changes
liquibase status

# Apply all changes
liquibase update

# Preview SQL (without executing)
liquibase update-sql

# Rollback last changeset
liquibase rollback-count 1

# Rollback to specific tag
liquibase rollback-to-tag v1.0.0

# Generate documentation
liquibase db-doc ./docs

# Clear checksums (use with caution)
liquibase clear-checksums

# Release database lock
liquibase release-locks
```

## 📋 Folder Structure Cheat Sheet

| Folder | Purpose | Example |
|--------|---------|---------|
| `01_tables/` | Table creation/alteration | CREATE TABLE, ALTER TABLE |
| `02_procedures/` | Stored procedures | CREATE PROCEDURE |
| `03_materialized_views/` | Materialized views | CREATE MATERIALIZED VIEW |
| `04_functions/` | Database functions | CREATE FUNCTION |
| `05_views/` | Regular views | CREATE VIEW |
| `06_triggers/` | Database triggers | CREATE TRIGGER |
| `07_indexes/` | Indexes | CREATE INDEX |
| `08_types/` | Custom types | CREATE TYPE |
| `09_inserts/` | Data inserts | INSERT INTO |
| `10_updates/` | Data updates | UPDATE |
| `11_rollbacks/` | Rollback scripts | DROP, DELETE, UPDATE |

## ⚠️ Important Rules

1. **Never modify executed changesets** - Always create a new changeset
2. **Always test locally first** - Use `liquibase validate` and `liquibase status`
3. **Use meaningful IDs** - Format: `{number}_{project}_{description}`
4. **Include rollback scripts** - For all destructive changes
5. **Follow semantic versioning** - For tags (v1.0.0, v1.1.0, v2.0.0)
6. **One change per file** - Keep SQL files focused
7. **Document everything** - Use comments in SQL and changesets

## 🔐 Security Best Practices

1. **Never commit credentials** - Use environment variables
2. **Use `.gitignore`** - Exclude sensitive files
3. **Set up CI/CD variables** - Store credentials in GitLab/GitHub secrets
4. **Limit production access** - Manual approval for production deployments
5. **Review before deploying** - Always check `liquibase status` output

## 🐛 Troubleshooting

### Checksum Validation Failed
```bash
liquibase clear-checksums
liquibase update
```

### Database is Locked
```bash
liquibase release-locks
```

### Connection Refused
- Check if database is running: `docker-compose ps`
- Verify connection settings in `liquibase.properties`
- Test connection: `psql -h localhost -U username -d dbname`

### Changeset Already Executed
- Don't modify executed changesets
- Create a new changeset for additional changes

## 📚 Additional Resources

- [Liquibase Documentation](https://docs.liquibase.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Liquibase Best Practices](https://docs.liquibase.com/concepts/bestpractices.html)
- [YAML Format Reference](https://docs.liquibase.com/concepts/changelogs/yaml-format.html)

## 💡 Tips & Tricks

1. **Generate UUIDs for changeset IDs**:
   ```bash
   # PowerShell
   [guid]::NewGuid()
   
   # Linux/Mac
   uuidgen
   ```

2. **Use contexts** for environment-specific changes:
   ```yaml
   context: dev,qa
   ```

3. **Use labels** for tracking tickets:
   ```yaml
   labels: JIRA-123,SPRINT-45
   ```

3. **Use preconditions** to check before running:
   ```yaml
   preconditions:
     - tableExists:
         tableName: example_table
   ```

4. **Generate SQL preview**:
   ```bash
   liquibase update-sql > preview.sql
   ```

5. **Test rollback before deploying**:
   ```bash
   liquibase update-testing-rollback
   ```

---

**Author:** Jesús Ariel González Bonilla

**Need Help?** Check the full [README.md](README.md) for detailed documentation.

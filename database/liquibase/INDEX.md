# 🚀 Liquibase Database Repository - Complete Template

[![Liquibase](https://img.shields.io/badge/Liquibase-4.28-blue.svg)](https://www.liquibase.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg)](https://www.postgresql.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **A complete, production-ready template for managing database schema evolution with Liquibase**

This repository provides a comprehensive structure and best practices for database version control using Liquibase. It includes examples, documentation, CI/CD setup, and everything you need to start a new Liquibase project.

---

## 📋 What's Included

- ✅ **Complete folder structure** (tables, procedures, views, functions, triggers, indexes, types, inserts, updates, rollbacks)
- ✅ **Example SQL scripts** for every database object type
- ✅ **Example changelogs** with proper YAML structure
- ✅ **CI/CD pipeline** (.gitlab-ci.yml) with validate, status, and update stages
- ✅ **Docker Compose** setup for local PostgreSQL database
- ✅ **Comprehensive documentation** (README, QUICKSTART, CONTRIBUTING, STRUCTURE)
- ✅ **Rollback examples** for safe database migrations
- ✅ **Git configuration** (.gitignore, .env.template)
- ✅ **No hardcoded credentials** - All sensitive data uses placeholders

---

## 🏗️ Repository Structure

```
manual-repo/
├── 01_tables/              # Database tables
├── 02_procedures/          # Stored procedures
├── 03_materialized_views/  # Materialized views
├── 04_functions/           # Database functions
├── 05_views/               # Regular views
├── 06_triggers/            # Database triggers
├── 07_indexes/             # Indexes
├── 08_types/               # Custom types
├── 09_inserts/             # Data inserts
├── 10_updates/             # Data updates
├── 11_rollbacks/           # Rollback scripts
├── changelog.yaml          # Master changelog
├── liquibase.properties    # Liquibase config
├── docker-compose.yml      # Local database setup
├── .gitlab-ci.yml          # CI/CD pipeline
└── docs/                   # Documentation
```

**📖 See [STRUCTURE.md](STRUCTURE.md) for detailed visual guide**

---

## ⚡ Quick Start

### 1️⃣ Prerequisites

- [Liquibase CLI](https://www.liquibase.org/download) (v4.28+)
- [PostgreSQL](https://www.postgresql.org/) (v13+)
- [Docker](https://www.docker.com/) (optional, for local development)
- [Git](https://git-scm.com/)

### 2️⃣ Setup

```bash
# Clone this repository
git clone <your-repo-url>
cd manual-repo

# Configure your database (edit liquibase.properties)
# Update: url, username, password

# Start local database (optional)
docker-compose up -d

# Validate setup
liquibase validate
```

### 3️⃣ Deploy

```bash
# Check pending changes
liquibase status

# Apply all changes
liquibase update
```

**🚀 That's it! Your database is now managed with Liquibase.**

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **[QUICKSTART.md](QUICKSTART.md)** | 5-minute quick start guide |
| **[README.md](README.md)** | Complete documentation (170+ lines) |
| **[STRUCTURE.md](STRUCTURE.md)** | Visual structure guide |
| **[CONTRIBUTING.md](CONTRIBUTING.md)** | Contribution guidelines |
| **[CHANGELOG.md](CHANGELOG.md)** | Version history |

---

## 🎯 Key Features

### 1. Organized Folder Structure
Each database object type has its own folder with examples:
- Tables, procedures, functions, views, triggers, indexes, types
- Separate folders for inserts, updates, and rollbacks

### 2. CI/CD Ready
Pre-configured GitLab CI/CD pipeline with:
- **Validation** stage (syntax check)
- **Status** stage (show pending changes)
- **Update** stage (deploy changes)
- Multi-environment support (dev, qa, staging, production)

### 3. Example Scripts
Complete working examples for:
- Creating tables with proper structure
- Stored procedures with parameters
- Materialized views for reporting
- Database functions (validation, calculations)
- Views for simplified access
- Triggers for automatic updates
- Indexes for performance
- Custom types (ENUM, composite)
- Data inserts and updates
- Rollback scripts

### 4. Best Practices
- **UUID-based changeset IDs** (avoids conflicts in team environments)
- Semantic versioning (v1.0.0)
- Conventional commit messages
- Proper changeset structure
- Rollback strategy
- Security guidelines (no credentials in code)
- Testing checklist
- Code review process

### 5. Multi-Environment Support
Configured for 4 environments:
- **develop** → Auto-deploy
- **qa** → Manual deploy
- **staging** → Manual deploy
- **main** → Manual deploy (production)

---

## 👤 Author

**Jesús Ariel González Bonilla**

---

## 🛠️ Common Tasks

### Create a New Table

```bash
# 1. Create SQL file
vi 01_tables/00003_my_new_table.sql

# 2. Add changeset to changelog
vi 01_tables/00000_changelog.yaml

# 3. Create rollback script
vi 11_rollbacks/01_tables/00003_my_new_table_rollback.sql

# 4. Test
liquibase validate
liquibase status
liquibase update
liquibase rollback-count 1  # Test rollback
liquibase update            # Re-apply
```

### Add a Stored Procedure

```bash
# 1. Create SQL file
vi 02_procedures/00002_p_my_procedure.sql

# 2. Add changeset
vi 02_procedures/00000_changelog.yaml

# 3. Test
liquibase update
```

### Insert Initial Data

```bash
# 1. Create insert script
vi 09_inserts/00002_insert_my_data.sql

# 2. Add changeset
vi 09_inserts/00000_changelog.yaml

# 3. Create rollback
vi 11_rollbacks/09_inserts/00002_insert_my_data_rollback.sql

# 4. Test
liquibase update
```

---

## 🔄 Workflow

```
1. Create branch (feature/TICKET-123-add-table)
2. Create SQL file in appropriate folder
3. Add changeset to 00000_changelog.yaml
4. Create rollback script (if needed)
5. Test locally (validate, status, update, rollback)
6. Commit with conventional message (feat: add user table)
7. Push and create Pull Request
8. Code review and approval
9. Merge to develop → auto-deploy to DEV
10. Merge to qa/staging/main → manual deploy
```

---

## 🔐 Security

- ✅ No credentials in `liquibase.properties` (use placeholders)
- ✅ `.env` file in `.gitignore`
- ✅ CI/CD variables stored in GitLab/GitHub secrets
- ✅ Production deployments require manual approval
- ✅ All sensitive files excluded from version control

---

## 📦 What's NOT Included

This template intentionally excludes:
- ❌ Actual database credentials (use your own)
- ❌ Production data or sensitive information
- ❌ JDBC driver (download from [PostgreSQL JDBC](https://jdbc.postgresql.org/download/))
- ❌ Liquibase CLI installation (download from [Liquibase.org](https://www.liquibase.org/download))

---

## 🎓 Learning Resources

- [Liquibase Official Docs](https://docs.liquibase.com/)
- [YAML Changelog Format](https://docs.liquibase.com/concepts/changelogs/yaml-format.html)
- [Liquibase Best Practices](https://docs.liquibase.com/concepts/bestpractices.html)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 💡 Tips

1. **Start simple** - Use the example scripts as templates
2. **Test locally** - Always run `liquibase validate` and `liquibase status` before pushing
3. **Use rollbacks** - Include rollback scripts for all destructive changes
4. **Follow conventions** - Stick to the naming conventions and folder structure
5. **Document everything** - Add comments to complex SQL and changesets
6. **Version carefully** - Follow semantic versioning for tags
7. **Review before merging** - Use the PR checklist in CONTRIBUTING.md

---

## 🆘 Troubleshooting

### Checksum Validation Failed
```bash
liquibase clear-checksums
liquibase update
```

### Database Locked
```bash
liquibase release-locks
```

### Connection Issues
- Check `liquibase.properties` configuration
- Verify database is running: `docker-compose ps`
- Test connection: `psql -h localhost -U username -d dbname`

---

## 🎉 Ready to Use!

This template is **production-ready** and can be used immediately for new Liquibase projects. Simply:

1. Copy/clone this folder
2. Update configuration files (liquibase.properties, docker-compose.yml)
3. Remove example scripts or use them as templates
4. Start creating your database schema!

---

## 📞 Support

- 📖 Check the documentation files
- 💬 Ask your team lead or DBA
- 🐛 Create an issue in your repository
- 📧 Contact the maintainers

---

**Made with ❤️ for database developers**

*Happy migrating! 🚀*

# 📁 Liquibase Repository Structure - Visual Guide

```
manual-repo/
│
├── 📋 Configuration Files
│   ├── liquibase.properties          # Main Liquibase configuration
│   ├── changelog.yaml                # Master changelog (includes all sub-changelogs)
│   ├── docker-compose.yml            # Docker PostgreSQL setup
│   ├── .gitlab-ci.yml                # CI/CD pipeline configuration
│   ├── .gitignore                    # Files to ignore in Git
│   └── .env.template                 # Environment variables template
│
├── 📚 Documentation
│   ├── README.md                     # Complete documentation
│   ├── QUICKSTART.md                 # 5-minute quick start guide
│   ├── CONTRIBUTING.md               # Contribution guidelines
│   ├── CHANGELOG.md                  # Version history
│   └── LICENSE                       # License file
│
├── 🗂️ Database Objects (Numbered folders for execution order)
│   │
│   ├── 01_tables/                    # 📊 Tables (CREATE/ALTER TABLE)
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml      # Changelog for tables
│   │   ├── 00001_example_table.sql
│   │   └── 00002_alter_example_table.sql
│   │
│   ├── 02_procedures/                # 🔧 Stored Procedures
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml
│   │   └── 00001_p_example_procedure.sql
│   │
│   ├── 03_materialized_views/        # 📈 Materialized Views
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml
│   │   └── 00001_mv_example_summary.sql
│   │
│   ├── 04_functions/                 # ⚙️ Functions
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml
│   │   └── 00001_f_example_function.sql
│   │
│   ├── 05_views/                     # 👁️ Views
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml
│   │   └── 00001_v_example_view.sql
│   │
│   ├── 06_triggers/                  # ⚡ Triggers
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml
│   │   └── 00001_tr_example_trigger.sql
│   │
│   ├── 07_indexes/                   # 🚀 Indexes
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml
│   │   └── 00001_idx_example_index.sql
│   │
│   ├── 08_types/                     # 🏷️ Custom Types
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml
│   │   └── 00001_type_example_custom_type.sql
│   │
│   ├── 09_inserts/                   # 📥 Data Inserts
│   │   ├── .gitkeep
│   │   ├── 00000_changelog.yaml
│   │   └── 00001_insert_config_data.sql
│   │
│   └── 10_updates/                   # 🔄 Data Updates
│       ├── .gitkeep
│       ├── 00000_changelog.yaml
│       └── 00001_update_config_values.sql
│
└── 🔙 Rollbacks
    └── 11_rollbacks/
        ├── 01_tables/
        │   └── 00001_example_table_rollback.sql
        ├── 02_procedures/
        │   └── 00001_p_example_procedure_rollback.sql
        ├── 09_inserts/
        │   └── 00001_insert_config_data_rollback.sql
        └── 10_updates/
            └── 00001_update_config_values_rollback.sql
```

## 🔢 Execution Order

Liquibase executes changesets in this order:

1. **01_tables/** → Create/modify table structures
2. **02_procedures/** → Add stored procedures
3. **03_materialized_views/** → Create materialized views
4. **04_functions/** → Add database functions
5. **05_views/** → Create views
6. **06_triggers/** → Add triggers
7. **07_indexes/** → Create indexes
8. **08_types/** → Define custom types
9. **09_inserts/** → Insert initial data
10. **10_updates/** → Update existing data

## 📝 File Naming Convention

```
{sequence_number}_{descriptive_name}.sql

Examples:
✅ 00001_create_users_table.sql
✅ 00002_add_email_index.sql
✅ 00003_insert_default_roles.sql

❌ create_users.sql (no sequence number)
❌ 1_users.sql (not zero-padded)
```

## 🏷️ Changeset Structure

```yaml
- changeSet:
    id: a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d  # Unique UUID
    author: your.email@company.com            # Author email
    context: project_name                     # Context/environment
    labels: TICKET-123                        # Ticket/issue reference
    comment: Brief description                # What this changeset does
    changes:
      - tagDatabase:
          tag: v1.0.0                         # Semantic version
      - sqlFile:
          path: 01_tables\00001_example.sql
          endDelimiter: \nGO
          stripComments: false
    rollback:                                 # Optional rollback
      - sqlFile:
          path: 11_rollbacks\01_tables\00001_example_rollback.sql
```

## 🚦 Deployment Flow

```
┌─────────────┐
│   develop   │──► Auto-deploy to DEV
└─────────────┘
       │
       ├─► Manual approval
       ▼
┌─────────────┐
│     qa      │──► Manual deploy to QA
└─────────────┘
       │
       ├─► Manual approval
       ▼
┌─────────────┐
│   staging   │──► Manual deploy to STAGING
└─────────────┘
       │
       ├─► Manual approval
       ▼
┌─────────────┐
│    main     │──► Manual deploy to PRODUCTION
└─────────────┘
```

## 🎯 Quick Actions

### Start Local Development
```bash
docker-compose up -d
liquibase validate
liquibase status
liquibase update
```

### Create New Table
1. Create: `01_tables/00XXX_my_table.sql`
2. Add to: `01_tables/00000_changelog.yaml`
3. Create: `11_rollbacks/01_tables/00XXX_my_table_rollback.sql`
4. Test: `liquibase update && liquibase rollback-count 1`

### Add Stored Procedure
1. Create: `02_procedures/00XXX_p_my_procedure.sql`
2. Add to: `02_procedures/00000_changelog.yaml`
3. Test: `liquibase update`

### Insert Data
1. Create: `09_inserts/00XXX_insert_data.sql`
2. Add to: `09_inserts/00000_changelog.yaml`
3. Create: `11_rollbacks/09_inserts/00XXX_insert_data_rollback.sql`
4. Test: `liquibase update && liquibase rollback-count 1`

## 🔐 Security Checklist

- [ ] No credentials in `liquibase.properties`
- [ ] `.env` file is in `.gitignore`
- [ ] CI/CD variables are set in GitLab/GitHub
- [ ] Production deployments require manual approval
- [ ] Database backups are in place before deployment

## 📊 Version Numbering

```
v1.0.0
│ │ │
│ │ └─► PATCH (bug fixes, minor updates)
│ └───► MINOR (new features, backward compatible)
└─────► MAJOR (breaking changes)
```

## 🛠️ Essential Commands

| Command | Purpose |
|---------|---------|
| `liquibase validate` | Check syntax |
| `liquibase status` | Show pending changes |
| `liquibase update` | Apply all changes |
| `liquibase update-sql` | Preview SQL |
| `liquibase rollback-count N` | Rollback N changesets |
| `liquibase rollback-to-tag TAG` | Rollback to version |
| `liquibase clear-checksums` | Fix checksum errors |
| `liquibase release-locks` | Release database lock |

## 💡 Best Practices

1. ✅ **Always test locally first**
2. ✅ **One logical change per changeset**
3. ✅ **Include rollback scripts**
4. ✅ **Use descriptive comments**
5. ✅ **Follow naming conventions**
6. ✅ **Never modify executed changesets**
7. ✅ **Document complex logic**
8. ✅ **Use semantic versioning**

## 📞 Need Help?

1. Check [QUICKSTART.md](QUICKSTART.md) for quick start
2. Read [README.md](README.md) for detailed docs
3. Review [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
4. Ask your team lead or DBA

---

**Visual Structure Ready!** 🎉

This template is ready to use for new Liquibase projects.

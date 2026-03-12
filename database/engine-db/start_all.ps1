# *******************************************************************************
# *                             INICIO AUTOMÁTICO                               *
# *******************************************************************************

# # PostgreSQL
# docker-compose -p databases -f ./postgres/docker-compose.yml up -d

# # MySQL
# docker-compose -p databases -f ./mysql/docker-compose.yml up -d

# # MongoDB
# docker-compose -p databases -f ./mongo/docker-compose.yml up -d

# # SQL Server
# docker-compose -p databases -f ./sqlserver/docker-compose.yml up -d

# # Cassandra
# docker-compose -p databases -f ./cassandra/docker-compose.yml up -d

# # SQLite
# docker-compose -p databases -f ./sqlite/docker-compose.yml up -d


# *******************************************************************************
# *                             INICIO MANUAL                                   *
# *******************************************************************************

# PostgreSQL
docker-compose -p databases -f ./postgres/docker-compose.yml up --no-start

# MySQL
docker-compose -p databases -f ./mysql/docker-compose.yml up --no-start

# MongoDB
docker-compose -p databases -f ./mongo/docker-compose.yml up --no-start

# SQL Server
docker-compose -p databases -f ./sqlserver/docker-compose.yml up --no-start

# Cassandra
docker-compose -p databases -f ./cassandra/docker-compose.yml up --no-start

# SQLite
docker-compose -p databases -f ./sqlite/docker-compose.yml up --no-start


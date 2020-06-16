# ArchivesSpace Development
[![CircleCI](https://circleci.com/gh/pulibrary/archivesspace-development.svg?style=svg)](https://circleci.com/gh/pulibrary/archivesspace-development)

## Prerequisites

### Docker

#### macOS

[Please download Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/)

### MySQL

#### macOS

Please install the `mysql` client using [Homebrew](https://brew.sh/):
```
brew install mysql
```

## Quality Assurance

### Running the MySQL server

```
cd db
docker-compose up
```

### Download the MySQL database export

(Please request this from an ArchivesSpace administrator, and save this into a file named `export.sql`)

### Loading the MySQL database export

Use the SQL export retrieved from above, please invoke the following:
```
mysql -h 0.0.0.0 -P 3306 -u as -p archivesspace < export.sql
```

(One will be prompted with `Enter password:`, please supply `as123`. Also, please 
note that the import of the data takes some time [between 3-4 minutes], as the export can be quite large.)

Now one should be able to connect to the database in the local environment using
the following:

host: `localhost`
user: `as`
password: `as123`
database: `archivesspace`

### Shutting down the MySQL server

From within the terminal running `docker-compose up`, please enter `^C` (the `control` and `c` keys)

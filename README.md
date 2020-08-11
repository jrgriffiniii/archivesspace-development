# ArchivesSpace Development
[![CircleCI](https://circleci.com/gh/jrgriffiniii/archivesspace-development.svg?style=svg)](https://circleci.com/gh/jrgriffiniii/archivesspace-development)

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

## Getting Started

### Installing ArchivesSpace
```
source ./scripts/install_aspace.sh
```

### Installing the l10n/i18n Configurations
```
source ./scripts/install_locales.sh
```

### Running the Docker Containers
```
source ./scripts/docker_up.sh
```

### Accessing the public user interface

- URL: [http://localhost/](http://localhost/)

### Accessing the staff user interface

- URL: [http://localhost/staff/](http://localhost/staff/)
- user: `admin`
- password: `admin`

### Loading the Princeton University Library Finding Aids (PULFA)

One must ensure that SVN is installed locally:

*In a macOS Environment:*
```
brew install svn
```

#### Using `lastpass-cli` for authentication [LastPass](https://lastpass.com)

*In a macOS Environment:*
```
brew install lastpass-cli
bundle install
```

Then please invoke the following:
```
lpass login username@domain.edu
bundle exec rake pulfa:checkout
```

#### Manually Retrieving the Documents (without `lpass`)
In order to download the EAD documents from Princeton University Library
servers, one will need to please retrieve the server name, as well as the
credentials for retrieving the documents from LastPass. Then, please download
the files with the following:

```
export PULFA_SERVER_URL=[the PULFA subversion URL]
export PULFA_USERNAME=[the PULFA subversion username]
svn checkout $PULFA_SERVER_URL --username $PULFA_USERNAME eads/pulfa/
```

### Cleaning the PULFA EAD Documents

The following `rake` task ensures that cleaned EAD Documents can be imported into ArchivesSpace:
```
bundle exec rake pulfa:clean
```

## Development

### Debugging

First, please ensure that `ruby-debug-base` is installed:
```
% jruby -S gem install ruby-debug-base
```

Then, please use the following environment variable to invoke `rake` tasks:
```
% JRUBY_OPTS=--debug bundle exec rake pulfa:clean
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

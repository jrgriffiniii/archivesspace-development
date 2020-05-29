# ArchivesSpace Development
[![CircleCI](https://circleci.com/gh/jrgriffiniii/archivesspace-development.svg?style=svg)](https://circleci.com/gh/jrgriffiniii/archivesspace-development)

## Getting Started

### Running the Docker Containers
```
git clone https://github.com/archivesspace/archivesspace.git
docker-compose up
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


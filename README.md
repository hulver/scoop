# scoop-ng

A replacement for scoop, mostly writen in node.js

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Clone the repo from https://github.com/hulver/scoop.git, connect it to your already running scoop database and go to town.


### Installing

To install.

Download or clone the repo, set the environment variables to point to your scoop database server

```
SCOOP_DB_USER=username
SCOOP_DB_PASS=password
SCOOP_DB_NAME=database name
SCOOP_DB_HOST=hostname

```

Then

```
npm install
npm start
```

## Running the tests

All tests (unit tests and others) can be run by

```
npm run test
```

## Deployment

There is no way of deploying this yet, it's not currently in a deployable state.

## Built With

* [Express](https://expressjs.com/) - The node.js web application framework

## Contributing

Currently you can contribute by submitting a pull request. 

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/hulver/scoop/tags). 

## Authors

* **Matthew Collins** - *Initial work* - [hulver](https://github.com/hulver)

See also the list of [contributors](https://github.com/hulver/scoop/contributors) who participated in this project.

## License

This project is licensed under the GNU Affero General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Shout out to the contributors of the original scoop system.
* Special thanks to the users of hulver.com, who are the only reason to keep this going.

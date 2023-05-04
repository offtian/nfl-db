# nfl_db

This repo holds the information to build a postgres container which allows running of most of nfl steps within SQL.


## QuickStart

### Building the image.


<details>
<summary> Show/Hide Details </summary>

There is a convenient [Makefile](Makefile) which should take care of the build.

It is however required to include an `.env` file.

The necessary `.env` variables are the following:

```
POSTGRES_PASSWORD=<POSTGRES_PASSWORD for postgres default user>
```

Once that is set up running

```bash
make build-nfl-pg
```

Within the repo should build the image. Please check the image name as specified in the `Makefile`

</details>

### Running postgres

<details>
<summary> Show/Hide Details </summary>

Running postgres locally, should be done using the [docker-compose.yml](docker-compose.yml) file by
executing:

```bash
docker-compose up
```

Optionally with a `-d` flag.


Because the `PGDATA` folder contains files generated at the image build phase, the database will fail to initilize. 

In order to resolve this, run 

```bash
make run-nfl-pg-init
```

This will initialize the database for the named volume which matches the production server. For local deployment with a bound volumes the user needs to initialize separately. 


For a production server the volumes should be managed by docker and an optimized
set of configuration parameters need to be defined stored in `postgresql.conf`.
These are managed by the [docker-compose.prod.yml](docker-compose.prod.yml) file which overrides the
relevant sections. Locally, data will be stored in `nflpgdata` in the same
current directory and is ignored by `.gitignore` and docker build context by
adding it in `.dockeringore`.

In order to run in production you can:

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

The [Makefile](Makefile) provides handy shortcuts to the above. It also provides
basic documentation for all make targets. Run:

```bash
make help
```

or just `make` and display the available make targets.


Finally, in order to enable python(3) in the database it is necessary to create
the extension:


```sql
CREATE EXTENSION plpython3u;
```

This is required in *each and every* created database.

</details>

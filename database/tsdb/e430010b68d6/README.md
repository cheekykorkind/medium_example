# InfluxDB OSS v2: Series Cardinality 3 vs. 100,000
## version
- influxdb : 2.7.5

## Docker compose
- Change directory
  - `cd APP_ROOT/database/tsdb/e430010b68d6`
- Run a Docker container in the foreground.
  - `docker compose up`
  - `docker exec -it e43-ruby /bin/bash`
  - `cd ruby`
  - Creating the Test Data
    - `ruby write.rb`
  - Querying the Test Data and Verifying the Results
    - `ruby query.rb`
# Property Fetch Service

## Overview
This project is a service that fetches the latitude and longitude of an object, along with its type and marketing type, and returns a list of similar objects with their prices.

## Running the Project Locally
To run the service locally, follow these steps:

1. Start the Rails server:
   ```sh
   rails s
   ```
2. Start Sidekiq:
   ```sh
   bundle exec sidekiq -C config/sidekiq.yml
   ```

## Docker Setup
The project includes a Docker setup that contains the following services:
- Rails API
- PostgreSQL
- PostgreSQL Admin
- Redis
- Sidekiq

### Build and Run the Docker Image

1. Set environment variables:
   ```sh
   export DATABASE_URL=postgres://user:password@localhost:5432/dbname
   export REDIS_URL=redis://localhost:6379/0
   ```
2. Build the Docker image:
   ```sh
   docker-compose build
   ```
3. Start the containers:
   ```sh
   docker-compose up
   ```

## Performance Considerations
- **PostgreSQL Functions for Distance Calculation**: PostgreSQL provides built-in functions to calculate distances efficiently. See [PostgreSQL EarthDistance](https://www.postgresql.org/docs/9.6/static/earthdistance.html) for details.
- **Scalability**: The service is designed to be easily scalable by running multiple Sidekiq workers and distributing database queries efficiently.
- **Response Time**: The service is optimized to handle requests efficiently, with a response time of **400-320 ms** for **1.75MB** of data.

## Additional Notes
- Ensure the Sidekiq worker processes are running correctly to fetch and cache data efficiently.
- The Redis cache is used to improve performance by reducing redundant database queries.
- API responses are structured for quick access and efficient frontend usage.

---
For any issues or improvements, feel free to submit a pull request or open an issue!


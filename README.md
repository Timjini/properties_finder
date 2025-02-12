# Property Fetch Service

## Overview

This project is a service that fetches the latitude and longitude of an object, along with its type and marketing type, and returns a list of similar objects with their prices.

## Running the Project Locally

To run the service locally, follow these steps:

1. **Start the Rails server.**
2. **Start Sidekiq.**

### Docker Setup

The project includes a Docker setup that contains the following services:

- Rails API
- PostgreSQL
- PostgreSQL Admin
- Redis
- Sidekiq

#### Build and Run the Docker Image

1. **Set environment variables** for the database and Redis.
2. **Build the Docker image.**
3. **Start the containers.**

## Performance Considerations

- **PostgreSQL Functions for Distance Calculation**: PostgreSQL provides built-in functions to calculate distances efficiently. Refer to the PostgreSQL EarthDistance documentation for details.
  
- **Scalability**: The service is designed to be easily scalable by running multiple Sidekiq workers and distributing database queries efficiently.

- **Response Time**: The service is optimized to handle requests efficiently, with a response time of 400-320 ms for 1.75MB of data.

## Scaling and Caching

### Redis for Caching and Scaling

To improve performance and scalability, this project integrates Redis for caching. Redis helps optimize data fetching by storing data and reducing the number of redundant database queries. This leads to faster responses and a more scalable system.

Additionally, Redis is used for managing background jobs via **Sidekiq**, allowing asynchronous processing of tasks such as fetching property data or calculating prices. This reduces load on the main application server and improves overall efficiency.

### Sidekiq for Background Jobs

Sidekiq is used to process background jobs asynchronously, improving scalability. For instance, tasks like fetching property details or calculating prices can be offloaded to background workers, allowing the main application to focus on handling incoming user requests.

### Caching Database Queries

Expensive or frequently accessed data can be cached to improve performance. By caching database queries with Redis, the service reduces the need to query the database repeatedly for the same data, which helps in improving response times and scalability.

### Geocoding with `geocoder`

The service uses geocoding functionality to fetch latitude and longitude for objects. To minimize external API calls and improve efficiency, geocoding results can be cached using Redis, ensuring that the same geocoding request does not need to be processed multiple times.

## Additional Notes

- Ensure that **Sidekiq workers** are running correctly to fetch and cache data efficiently.
- The **Redis cache** plays a key role in improving performance by reducing redundant database queries and enhancing response times.
- API responses are structured for **quick access** and **efficient frontend usage**.

For any issues or improvements, feel free to submit a pull request or open an issue!

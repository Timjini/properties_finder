# Use the official lightweight Ruby image
FROM ruby:3.1.2-slim

# Set working directory inside the container
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock before installing dependencies (leveraging Docker cache)
COPY Gemfile Gemfile.lock ./

# Install Bundler and gems
RUN gem install bundler && bundle install

# Copy the application source code
COPY . .

# Expose the port Rails will run on
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]

# Dependencies

1. Ruby 2.7.3
2. Bundler 2.2.9
3. Rails 6.1.3
4. Postgres

# Installation

1. `bundle install`
2. `rake db:setup`

# Seed the database
`rake db:seed`

# Running the Specs
`rails spec` or `rspec spec`

# Start the Server
`rails s`

# Select a test User

In a separate tab

1. Start the `rails c` and select a `User#email` (i.e. `User.first.email`)
2. Password is `password`
 
# Run the frontend

In a separate tab:

1. Navigate to the `he-better-reads-frontend`
2. Run `yarn install`
3. Run `yarn start`
4. Visit `http://localhost:3001`

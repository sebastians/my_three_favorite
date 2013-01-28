# My Three Favorite

This is a toy app that fetches your three favorite Twitter accounts timeline using Twitter's API.

### It's alive!

Click here to [see](http://mythreefavorite.herokuapp.com/) it alive.

### To run tests locally

First you must set your credentials, to use Twitter API. See `config/initializers/twitter.rb` and read [this](https://dev.twitter.com/).

Follow this steps:
  1. Clone the repository: `git clone git@github.com:sebasoga/my_three_favorite.git`
  2. Get into the projects folders: `cd my_three_favorite`
  3. Install the dependencies: `bundle install`
  4. Setup the database: `rake db:setup`.
  5. Run the tests: `rake`

You must have Git, Ruby 1.9.3 and Bundler installed and an internet conection.

This project will be soon running its test suite on Travis CI.

# Rails Engine

The goal of this project was to expose data that powers an e-commerce site through an API that the front end will consume. Since this application is working in a service-oriented architecture, the front and back ends of this application are separate and communicate via APIs.

The full specifications can be found
[here](https://backend.turing.io/module3/projects/rails_engine/).

An example endpoint, viewed using [Postman](https://www.postman.com/):
![API call](https://user-images.githubusercontent.com/7945439/103421886-f46fb200-4b5b-11eb-9e3d-d572d47f3ab3.png)

## Summary

  - [Getting Started](#getting-started)
  - [Runing the tests](#running-the-tests)
  - [Author](#author)

## Getting Started

### Prerequisites

These setup instructions are for Mac OS.

This project requires the use of `Ruby 2.5.3` and `Rails 5.2.4.3`. We use `PostgreSQL` as our database.

### Installing

To setup locally, follow these instructions:
  * __Create a folder called “e-commerce application” and inside of that folder, do the following:__
    * Clone [Rails Driver](https://github.com/turingschool-examples/rails_driver)
    * Clone [this repo](https://github.com/stillsheryl/rails_engine) in the same “e-commerce application” folder
    * Note: these two folders will both live side-by-side inside the "e-commerce application" folder.
  * __Navigate into rails-engine file__
    
  * __Install Gems__
    * Run `bundle install` to install all gems in the Gemfile
  * __Set Up Local Database and Migrations__
    * Run `rails db:{create,migrate,seed}`

## Running the tests

Run the command `bundle exec rspec` in the terminal while inside of the `rails_engine` file. You should see all passing tests.

In order to run the tests for the `rails_driver`, you must have a terminal window where you run the server for the `rails_engine`. To do this, you can open a separate tab in your terminal, navigate to `rails_engine`, and type `$ rails s` into the terminal. Then, in the terminal tab which is inside the `rails_driver` folder, you can run the command `bundle exec rspec` and see all passing tests.

## Author

  - **Sheryl Stillman** - [Github Profile](https://github.com/stillsheryl) - [Turing Alum Profile](https://alumni.turing.io/alumni/sheryl-stillman) - [LinkedIn](https://www.linkedin.com/in/sherylstillman1/)

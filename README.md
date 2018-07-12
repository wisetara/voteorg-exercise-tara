# Address Validator Coding Challenge

Having accurate addresses is important for Vote.org. In this challenge you will be given a
very basic rails app that consists of a form with a field for
- street address
- city
- state
- zip

The goal is to have the form validate the input to see if it forms a valid address
and if so, save the address components in the respective columns.

While not all addresses will have a value for every column it is important not to lose any
address information provided. For example if an address post direction value or unit value
is provided, those must be saved. Additionally any addresses that are not real addresses
should not be saved. As a rule, all addresses should have
 - house number
 - street name
 - city
 - state (saved as 2 letter state abbreviation)
 - 5 digit zip code (only numbers)

It is your job to update the Address model and controller so that all validated
addresses are saved to the database and no invalid addresses are saved. The Address model
also has a `#to_s` method that needs to be filled in so that it returns the address as
a string.

While front end validation and feedback to the user is expected, you should not rely only on
front end validations. Additionally a suggested layout has been included in a file labeled
"wireframe.png". Feel free to use this mock or come up with a different design of the frontend.

A few test cases have been provided to help get you started. You are encouraged to write more
tests as you go, but DO NOT delete any of the existing tests. Also, you may not change the
schema.

## Prerequisites

You'll need the following installed on your system:
1. ruby
2. rails
3. sqlite3

Instructions can be found here: http://guides.rubyonrails.org/getting_started.html#installing-rails

## Getting started

To run the project as is:
1. `bundle install`
2. `rake db:create`
3. `rake db:migrate`
4. `rails s`

To run the tests:
1. `rails generate rspec:install`
  (When prompted to overwrite spec/spec_helper.rb enter `n`)
2. `rspec` (or `bundle exec rspec`)

If everything is set up properly you should see `10 examples, 7 failures` to start.

Here are some useful resources for Ruby On Rails:
- https://www.tutorialspoint.com/ruby-on-rails/rails-controllers.htm
- http://guides.rubyonrails.org/active_model_basics.html
- http://guides.rubyonrails.org/action_controller_overview.html
- http://guides.railsgirls.com/app
- https://www.railstutorial.org/book/toy_app
- https://relishapp.com/rspec/rspec-rails/v/3-7/docs (docs for rspec testing)

Information on Address standards / validations:
- https://pe.usps.com/text/pub28/28c1_001.htm

Here are some services that can be used for address validation:
- https://developers.google.com/maps/documentation/geocoding/intro
- https://wiki.openstreetmap.org/wiki/Nominatim
- https://developers.arcgis.com/rest/geocode/api-reference/overview-world-geocoding-service.htm
If you need an api key or are interested in using another service please let us know.

Your finished project should:
- validate addresses
- not save any invalid addresses
- be styled on the front end
- validate fields on the front end
- display feedback to the user
- be well-tested

When submitting the project please answer the following questions:
 1. What gems if any did you choose to use and why?
    Github listed some security vulnerabilities, which led me to force some dependency
    versions for `nokogiri` (which is at the top, because I know it likes it there),
    `rails-html-santizer`, `sprockets`, and `loofah`.

    I added the `geocoder` gem, which works quite nicely with ruby and doesn't require an
    outside service (for my/our purposes). If I don't have to rely on an outside service,
    I don't have to worry about that dependency changing, AND one can add a `geocoder`
    initializer and specify using a particular outside service, should one choose to do so.

    I also added two tools: `pry-byebug` and `rubocop`. `pry-byebug` is great for walking
    through code, either to debug it or more fully understand it. `rubocop` helps keep
    style consistent and often adds some speedy features. In this case, I checked for
    egregious things, but most of the warnings and errors `rubocop` found were pre-existing
    or often ignored, so I ignored those.
 2. Were there any specific challenges or struggles you faced along the way?
    The biggest challenges included making sure to format my geocoded results in a way
    that made them most useful, and related to that, pulling apart the street name, dividing
    it into directions, street type, etc. There was a lot of specificity to the tests,
    and while I got at each requirement, it wasn't always straightforward! I wanted to think
    through worst-case scenarios.
 3. Is there anything you'd want to improve or optimize if you had more time?
    So many things! But the main thing I'd do now is adjust for case--I'd probably make sure
    my user input was adjusted to all one case--probably downcase, and then I'd adjust
    the case into the format in which I wanted to store things. I have an odd last name,
    though, so I MIGHT use my last name as a test. And I might even let the input case go
    straight into the database for names.
 4. If you were to take this project to production, what would be on your list of things to
    do?
    Well, the above case things. I'd probably lock into a geocoding service I wanted to use
    if there's one already in use. I'd do more work with security and a11y. I'd want to make
    sure any environment variables were in the right place. And I'd probably either attempt
    a refactor, ask someone more senior than me to work on a refactor, and/or extract
    the address validation service into a separate app/microservice so that it could be more widely utilized--and do the refactoring required for that.

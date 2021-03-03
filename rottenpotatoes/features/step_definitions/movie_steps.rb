# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  ratings = rating_list.split(", ")
  #   iterate over the ratings and reuse the "When I check..." or
  ratings.each do |rating|
    if uncheck
      uncheck("ratings_" + rating)
    #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
    else
      check("ratings_" + rating)
    end
  end
  # Other implementation, get Movie.all_ratings. loop each element => check if in checklist, uncheck otherwise
  # Using this implementation only need 1 step rather than 2 (1 check, 1 uncheck)
end

When /I click button (.*)/ do |button|
  click_button(button)
end

Then /I should( not)? see movies with the following ratings: (.*)/ do |notsee, rating_list|
  ratings = rating_list.split(", ")
  # get the movies list correspond to te rating_list
  movies = []
  ratings.each do |rating|
    filter_movies = Movie.where("rating = ?", rating)
    movies.concat(filter_movies)
  end
  # check if not see is not showing up and see is showing up
  if notsee
    movies.each do |movie|
      expect(page).to have_no_content(movie.title)
    end
  else
    movies.each do |movie|
      expect(page).to have_content(movie.title)
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  expect(page.all("table#movies tr").count - 1).to eq 10 # -1 header row
end

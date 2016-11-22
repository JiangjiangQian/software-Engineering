value = 0
Given /the following movies exist/ do |movies_table|
  value = 0
  movies_table.hashes.each do |movie|
      Movie.create(movie)
      value += 1
  end
end


Then /^the director of "(.*)" should be "(.*)"$/ do |title_value, director_value|
   movie= Movie.find_by_title(title_value)
   expect(movie.director).to eq director_value
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |movie_title1, movie_title2|
 #  ensure that that e1 occurs before e2.
 #  page.body is the entire content of the page as a string.
 body = page.body
 location_of_movie_title1_in_body = body.index(movie_title1)
 location_of_movie_title2_in_body = body.index(movie_title2)
 loc1 = location_of_movie_title1_in_body
 loc2 = location_of_movie_title2_in_body
 if loc1==nil || loc2==nil
     fail "One of both search parameters not found"
 else
     expect(loc1<loc2).to eq true
 end
end

Then /I should see all of the movies/ do
  page.should have_css("table#movies tbody tr",:count => value.to_i)
end

Then /I should not see any of the movies/ do
  movies = Movie.all
  movies.each do |movie|
    assert true unless page.body =~ /#{movie.title}/m
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.delete!("\"")
  if uncheck.nil?
    rating_list.split(',').each do |field|
      check("ratings["+field.strip+"]")
    end
  else
    rating_list.split(',').each do |field|
      uncheck("ratings["+field.strip+"]")
    end
  end
end
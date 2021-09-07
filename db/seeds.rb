###################################################################################
###########################  Destroy all existing data  ###########################
###################################################################################

if Rails.env.development?
  Rake::Task['db:environment:set'].invoke(['RAILS_ENV=development'])
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:schema:load'].invoke
end


###################################################################################
#############################  Setup Authors and Books  ###########################
###################################################################################

20.times { FactoryBot.create(:author) }

Author.all.each do |author|
  (1..5).to_a.sample.times { FactoryBot.create(:book, author: author) }
end


###################################################################################
#############################  Setup Reviews and Users  ###########################
###################################################################################

books = Book.all
count = books.size

books.each_with_index do |book, index|
  puts "Creating reviews, #{index + 1} of #{count}..."

  (1..10).to_a.sample.times {
    review = FactoryBot.create(
      :review,
      reviewable: book,
      user: FactoryBot.create(:user),
      rating: (1..5).to_a.sample
    )
  }
end


###################################################################################
#################################  Report results  ################################
###################################################################################

p 'Successful db seeding. Created:'

p "#{User.count} User records"
p "#{Author.count} Author records"
p "#{Book.count} Book records"
p "#{Review.count} Review records"

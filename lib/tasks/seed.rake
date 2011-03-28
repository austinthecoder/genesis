namespace :seed do
  desc "creates a user for dev env"
  task :dev_user => :environment do
    User.create!(
      :email => 'soccer022483@gmail.com',
      :name => 'Austin Schneider',
      :password => 'secret',
      :password_confirmation => 'secret',
      :site => Site.create!(:domain => 'app.local')
    )
  end
end
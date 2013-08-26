# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

group = Group.create!(
    {
        :name => 'Slalom Digital'
    }
)

user = User.create!(
    {
        :email => 'admin@slalom.com',
        :password => 'race2win',
        :password_confirmation => 'race2win',
    }
)


App.create!(
    {
        :name => 'MLevel iOS',
        :identifier => 'com.slalom.mlevel',
        :app_type => 'iOS',
        :url => 'https://itunes.apple.com/us/app/mlevel/id577848463',
        :group => user
    }
)

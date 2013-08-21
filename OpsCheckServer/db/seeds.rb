# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user = User.create(
    {
        :email => 'giuseppem@slalom.com',
        :password => '11031984',
        :password_confirmation => '11031984'
    }
)

user.save

app = App.create(
    {
        :name => 'SmartAlert iOS',
        :identifier => 'com.slalom.SmartAlert',
        :app_type => 'iOS',
        :url => 'https://itunes.apple.com/us/app/mlevel/id577848463',
        :user => user
    }
)
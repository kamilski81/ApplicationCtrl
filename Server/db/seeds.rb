# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin_role = Role.find(1)
group_admin_role = Role.find(2)
group_manager_role = Role.find(3)


group = Group.create!(
    {
        :name => 'Slalom Digital'
    }
)

admin = User.create!(
    {
        :email => 'admin@slalom.com',
        :password => 'race2win',
        :password_confirmation => 'race2win',
    }
)
admin.groups << group
admin.roles << admin_role
admin.save!

group_admin = User.create!(
    {
        :email => 'group_admin@slalom.com',
        :password => 'race2win',
        :password_confirmation => 'race2win',
    }
)
group_admin.groups << group
group_admin.roles << group_admin_role
group_admin.save!

group_manager = User.create!(
    {
        :email => 'group_manager@slalom.com',
        :password => 'race2win',
        :password_confirmation => 'race2win',
    }
)
group_manager.groups << group
group_manager.roles << group_manager_role
group_manager.save!

App.create!(
    {
        :name => 'MLevel iOS',
        :identifier => 'com.slalom.mlevel',
        :app_type => 'iOS',
        :url => 'https://itunes.apple.com/us/app/mlevel/id577848463',
        :group_id => group.id
    }
)

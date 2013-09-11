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
        :name => 'ADMIN'
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


group = Group.create!(
    {
        :name => 'Slalom Digital'
    }
)

group_admin = User.create!(
    {
        :email => 'group_manager@slalom.com',
        :password => 'race2win',
        :password_confirmation => 'race2win',
    }
)
group_admin.groups << group
group_admin.roles << group_admin_role
group_admin.save!

group_manager = User.create!(
    {
        :email => 'contributor@slalom.com',
        :password => 'race2win',
        :password_confirmation => 'race2win',
    }
)
group_manager.groups << group
group_manager.roles << group_manager_role
group_manager.save!

power_up = App.create!(
    {
        :name => 'PowerUp',
        :identifier => 'com.slalom.PowerUp',
        :app_type => 'iOS',
        :url => 'https://itunes.apple.com/us/app/powerup/id577848463',
        :group_id => group.id
    }
)

Versioning.create!(
    {
       :version => '1.0',
       :build => '1.0',
       :app => power_up
    }
)


group = Group.create!(
    {
        :name => 'MLevel'
    }
)

m_level = App.create!(
    {
        :name => 'MLevel iOS',
        :identifier => 'com.slalom.mlevel',
        :app_type => 'iOS',
        :url => 'https://itunes.apple.com/us/app/mlevel/id577848463',
        :group_id => group.id
    }
)

Versioning.create!(
    {
        :version => '1.0',
        :build => '1.0',
        :app => m_level
    }
)

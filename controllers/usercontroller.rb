require './models/user'

class UserController
    def self.add_user(params)
        user = User.new(params)
        user.save
    end
end

module ControllerMacros
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.build(:user)
      user.save!(validate: false)
      sign_in user
      user
    end
  end
end

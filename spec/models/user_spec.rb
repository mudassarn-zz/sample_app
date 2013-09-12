require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Test1", email:"test1.cmu.edu", password: "mudassar", password_confirmation: "mudassar" )
  end

  subject {@user}
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation) }
  it { should respond_to (:authenticate)}
  it { should be_valid }
  
  describe "when name is not present" do
    before do
      @user.name = "  "
    end
    it { should_not be_valid }
  end  
  describe "when email is not present" do
    before do
      @user.email = "  "
    end
    it {should_not be_valid}
  end
  describe "when name length is larger than 50 characters" do
    before {@user.name = "a"*51}
    it {should_not be_valid}
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[abc.dce@yahoo,com blank.com abcd@yahoo abc@yahoo. dec@danta. dec.@danta dec.@danta.com dec@.com dec@.baba.com foo@bar+baz.com foo@bar_abc.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[abc.dce@yahoo.com abcd@yahoo.com dec_baba@danta.com dec_bab@mail.yahoo.com a+b@yahoo.com AZ-az@yahoo.abc.com]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  describe "when email is not unique" do
    before do
      same_user = @user.dup
      same_user.email = @user.email.upcase
      same_user.save
    end
    it { should_not be_valid}
  end
  describe "when password is not present" do
    before do
      @user.password=" "
    end
    it {should_not be_valid}
  end
  describe "when password does not match with confirmed password" do
    before {@user.password_confirmation="mismatched"}
    it {should_not be_valid}
  end
  describe "return value of authenticate user" do
    before {@user.save}
    let (:found_user) {User.find_by_email(@user.email)}
    describe "with valid password" do
      it {should eq found_user.authenticate(@user.password)}
    end
    describe "with invalid password" do
      let (:user_for_invalid_password) {found_user.authenticate("Invalid")}
      it {should_not eq user_for_invalid_password}
      specify {expect(user_for_invalid_password).to be_false }
    end
  end
  describe "when password is too short" do
    before {@user.password = @user.password_confirmation = "a"*5}
    it {should_not be_valid}
  end
end

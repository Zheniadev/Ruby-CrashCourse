require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'spec_helper'

RSpec.describe 'Login Tests' do
  let(:password) { 'secret_sauce' }
  let(:incorrect_password) { '74543' }

  before(:each) do
    @driver = Capybara::Session.new(:selenium)
    @driver.visit @url
  end

  context "Login with username and password" do
    usernames = ['error_user', 'locked_out_user', 'standard_user']
    usernames.each do |username|
      it "attempt by user #{username} to log in" do
      if username == 'error_user'
        login_as(username, incorrect_password)
        expect_error("Epic sadface: Username and password do not match any user in this service")
      elsif username == 'locked_out_user'
        login_as(username, password)
        expect_error("Epic sadface: Sorry, this user has been locked out.")
      else
        login_as(username, password)
      end
    end
  end
  context "Shopping Cart Tests" do
    it "add two items to the cart after successful login" do
      login_as('standard_user', password)
      add_item_to_cart(1)  
      add_item_to_cart(2)  
      check_cart_items_count(2)
    end
  end

  def login_as(username, password)
    @driver.fill_in 'user-name', with: username
    @driver.fill_in 'password', with: password
    @driver.click_button('Login')
  end

  def expect_error(message)
    expect(@driver).to have_selector('[data-test="error"]', text: message)
  end

  def add_item_to_cart(item_index)
    @driver.find(:css, ".inventory_item:nth-child(#{item_index}) .btn_inventory").click
  end

  def check_cart_items_count(expected_count)
    @driver.find('.shopping_cart_link').click 
    expect(@driver).to have_selector('.cart_item', count: expected_count)
  end
end
end

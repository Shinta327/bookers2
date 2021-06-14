class UsersController < ApplicationController
  def index
  end

  def show
    @book = Book.new
  end
end

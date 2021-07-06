class SearchsController < ApplicationController
  before_action :authenticate_user!
  def search
    @model = params["model"]
    @content = params["content"]
    @method = params["method"]
    @records = search_for(@model, @content, @method)
  end
  
  private
  def search_for(model, content, method)
    if model == 'user'
      if method == 'perfect'
        User.where(name: content)
      elsif method == 'forword'
        User.where('name like ?', "#{content}%")
      elsif method == 'backword'
        User.where('name like ?', "%#{content}")
      else
        User.where('name like ?', "%#{content}%")
      end
      
    elsif model == 'book'
      if method == 'perfect'
        Book.where(body: content)
      elsif method == 'forword'
        Book.where('body like ?', "#{content}%")
      elsif method == 'backword'
        Book.where('body like ?', "%#{content}")
      else
        Book.where('body like ?', "%#{content}%")
      end
    end
  end
end

class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    current_user.active_relationships.create
    current_user.follow(user)
    redirect_to request.referer
  end

  def destroy
    user = Relationship.find_by(follower_id: params[:user_id], follower_id: current_user.id).followed
    current_user.unfollow(user)
    redirect_to request.referer
  end
end

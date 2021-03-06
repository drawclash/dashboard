class LikesController < ApplicationController

  before_action :find_entity


  def create
    @entity.likes.push current_user.id
    @entity.save
    Analytics.track(event: "Liked #{ @entity.class.name }", user_id: current_user.id, properties: {id: @entity.id})
    render nothing: true, status: :created
  end

  def destroy
    @entity.likes_will_change!
    @entity.update likes: (@entity.likes - [current_user.id])
    Analytics.track(event: "Disliked #{ @entity.class.name }", user_id: current_user.id, properties: {id: @entity.id})
    render nothing: true, status: :no_content
  end


  private

  def find_entity
    @entity = case true
    when params[:entry_id].present? then Entry.find_by!(id: params[:entry_id])
    when params[:post_id].present?  then Post.find_by!(id: params[:post_id])
    end
  end

end

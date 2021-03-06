class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :authorize, :current_user, :check_pending_requests, :check_for_requests, :num_of_pending_requests, :friend_check,
  :check_for_requests_second, :check_for_requests_first
  # before_action :set_last_seen_at, if: proc { logged_in?}

  def authorize
    unless logged_in?
      flash[:message] = "Whoops, you need to log in to do that!"
      redirect_to new_session_path
    end
  end

  def logged_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def check_pending_requests
    @all = FriendRequest.all
    @pending_requests = @all.find_all do |req|
      req.receiver_id == current_user.id && req.status == "pending"
    end
  end

  def num_of_pending_requests
    @all = FriendRequest.all
    @all.select do |req|
      req.receiver_id == current_user.id && req.status == "pending"
    end.count
  end


  def check_for_requests_first
    FriendRequest.all.find_all do |req|
    req.receiver_id == @profile.user_id && req.sender_id == current_user.id && req.status == "pending"
    end
  end

  def check_for_requests_second
    FriendRequest.all.find_all do |req|
      req.receiver_id == current_user.id && req.sender_id == @profile.user_id && req.status == "pending"
    end
  end

  def friend_check
    current_user.friends.include?(@profile.user)
  end

  def set_last_seen_at
    a = current_user.last_seen_at
     current_user.update_column(:last_seen_at, DateTime.now.strftime)
    a
  end

end

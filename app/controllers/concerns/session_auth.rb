module SessionAuth
  extend ActiveSupport::Concern

  StepsCount     = 10
  ExpirationTime = 20

  included do
    after_action :check_steps_count, :check_session_time
  end

  private

  def check_steps_count
    session[:steps_count] ||= 0
    session[:steps_count]  += 1
    regenerate_token && session.delete(:steps_count) if session[:steps_count] >= StepsCount
  end

  def regenerate_token
    if current_user
      current_user.generate_token && current_user.save
      new_token = current_user.token
      session.delete(:token)
      session[:token] = new_token
    end
  end

  def check_session_time
    if current_user && check_time
      current_user.touch(:expire_session)
    end
  end

  def check_time
    current_user.expire_session < Time.now - ExpirationTime.seconds
  end
end
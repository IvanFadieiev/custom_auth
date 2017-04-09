module SessionAuth
  extend ActiveSupport::Concern

  STEPS_COUNT     = 10
  EXPIRATION_TIME = 200.seconds

  included do
    after_action :step_relogin!, :time_relogin!
  end

  protected

  def step_relogin!
    steps_count_incrementing
    change_session_user_token! && session.delete(:steps_count) if check_steps_count
  end

  def time_relogin!
    if current_user && check_time
      current_user.touch(:expire_session)
    end
  end

  def regenerate_token!
    current_user.generate_token && current_user.save
  end

  def check_time
    current_user.expire_session < Time.now - expiration_time
  end

  def steps_count
    STEPS_COUNT
  end

  def expiration_time
    EXPIRATION_TIME
  end

  def steps_count_incrementing
    session[:steps_count] ||= 0
    session[:steps_count]  += 1
  end

  def change_session_user_token!
    if current_user
      regenerate_token!
      new_token = current_user.token
      session.delete(:token)
      session[:token] = new_token
    end
  end

  def check_steps_count
    session[:steps_count] >= steps_count
  end
end
class RegistersController < ApplicationController
  unauthenticated_access_only

  def show
    if @current_user.present?
      redirect_to projects_path, notice: "You are already registered." and return
    end
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to projects_path, notice: "Welcome to PreTeXt.Plus!"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.expect(user: [ :email_address, :password, :invite_code ])
  end
end

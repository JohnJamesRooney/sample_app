class UsersController < ApplicationController

  before_action :signed_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :not_signed_in_user,  only: [:new, :create ]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    if signed_in?
      redirect_to(root_url)
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Success
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    targetUser = User.find(params[:id])
    if current_user? targetUser
      flash[:error] = "Can not delete own admin account!"
    else
      targetUser.destroy
      flash[:success] = "User deleted. ID: #{targetUser.id}"
    end
    redirect_to users_url
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    def not_signed_in_user
      redirect_to(root_url) unless !signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) 
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

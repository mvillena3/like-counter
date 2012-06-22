
class UsersController < ApplicationController
  before_filter :signed_in, only: :index
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # This page displays the users with a like button next to each
  def like_page
    @users = User.all order: 'likes DESC'
  end

  # This method increments a user's likes by 5
  def likes
    if signed_in?
      user_liked = User.find_by_id!(params[:id])
      user_liked.increment!(:likes, 5)
      user_who_likes = current_user
      user_who_likes.decrement!(:likes, 5)
      user_liked.save!
      user_who_likes.save!
      sign_in current_user 
      redirect_to root_path 
    else
      redirect_to new_session_path, flash: { notice: 'Hey, we need to know who you are first' }
    end
  end

  private
  
  def signed_in
    redirect_to new_session_path, notice: 'Gotta sign in' unless signed_in?
  end

end

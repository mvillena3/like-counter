
class UsersController < ApplicationController
#  before_filter :signed_in, only: [:index, :edit, :show]
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
        format.html { redirect_to @user, success: 'Welcome to your profile page.' }
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
        sign_in @user
        format.html { redirect_to @user, 
          flash: { success: 'Your account information was successfully updated.' }
        }
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

  # This page displays the users with their number of likes 
  def like_page
    @users = User.all order: 'likes DESC'
  end

  def email_likes
    if params[:email_address]
      # Determines whether the user who likes is in database or not
      # If the user is not in database, we simply create a user
      user_who_likes = User.find_by_email(params[:who_likes]) ? 
        User.find_by_email_address(params[:who_likes]) :
        User.create(email_address: params[:who_likes], 
                    name: 'stub_name',
                    password: "#{params[:who_likes]}",
                    password_confirmation: "#{params[:who_likes]}"
                   )
      liked_user = User.find_by_id(params[:id])
      User.incr_decr_likes(liked_user, user_who_likes)
      success_msg = "Thanks for liking.  Feel free to close the window if you'd like"
      redirect_to root_path, flash: { success: success_msg } 
    else
      redirect_to root_path, flash: { error: 'Invalid request' }
    end
  end

  # This method increments a user's likes by 5
  def likes
    if signed_in? 
      liked_user = User.find_by_id!(params[:id])
      user_who_likes = current_user
      User.incr_decr_likes(liked_user, user_who_likes)
      sign_in user_who_likes
      redirect_to root_path 
    else
      redirect_to new_session_path, flash: { notice: 'Hey, we need to know who you are first' }
    end
  end


  private

  def signed_in
    redirect_to new_session_path, notice: 'Gotta sign in to do that' unless signed_in?
  end

end

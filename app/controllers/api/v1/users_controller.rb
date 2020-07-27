class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    json_users = UserSerializer.new(@users).serialized_json
    render json: json_users
  end

  # GET /users/1
  def show
    json_user = UserSerializer.new(@user).serialized_json
    render json: json_user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    
    if @user.save
      habits = [
        'Exercise',
        'Drink 6 Cups of Water',
        'Meditate',
        'Stay Home'
      ]
      habits.each {|h| @user.habits.build(name: h)}
      @user.save
      session[:user_id] = @user.id
      render json: UserSerializer.new(@user), status: :created
    else
      resp = {
        error: @user.errors.full_messages.to_sentence
      }
      render json: resp, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :username, :email, :password)
    end
end

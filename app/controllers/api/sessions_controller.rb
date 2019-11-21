class Api::SessionsController < Devise::SessionsController
    before_action :ensure_params_exist, only: [:create]
    before_action :load_user_authentication, except: [:destroy]
    skip_before_action :verify_signed_out_user, only: [:destroy]
  
    respond_to :json
  
    def create
      if @user.valid_password? user_params[:password]
        sign_in @user, store: false
        render json: {status: "success", message: "Signed in successfully",
          data: @user}, status: 200
        return
      end
      invalid_login_attempt
    end
  
    def destroy
      @current_user = current_user
      if !@current_user.nil? #token thông qua query string
        delete_token @current_user
        render json: {status: "success", message: "Logged out successfully!"}, status: 200
      else
        render json: {status: "error", message: "Invalid token"}, status: 200
      end
    end
  
    private
    def delete_token(current_user)
      current_user.authentication_token = ""
      current_user.save
    end
    def user_params
      params.require(:user).permit :email, :password, :authentication_token
    end
  
    def invalid_login_attempt
      render json: {status: "error",message: "Sign in failed"}, status: 200
    end


    def current_user
        @current_user ||= User.find_by authentication_token: request.headers["Authorization"] #token thông qua header
      end
    
      def authenticate_user_from_token
        render json: {status: "error",message: "You are not authenticated"},
          status: 401 if current_user.nil?
      end
      end
    
      def ensure_params_exist
       return unless params[:user].blank?
        render json: {status: "error",message: "Missing params"}, status: 422
      end
    
      def load_user_authentication
        @user = User.find_by_email user_params[:email]
        return login_invalid unless @user
      end
    
      def login_invalid
        render json:
          {status: "error", message: "Invalid login"}, status: 200
      end
  
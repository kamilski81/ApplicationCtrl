class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:show, :edit, :update, :destroy]

  # cancan
  load_and_authorize_resource
  skip_authorize_resource :only => :new

  # cancan exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end


  # GET /apps
  def index
  end

  # GET /apps/1
  def show
  end

  # GET /apps/new
  def new
    @app = App.new
  end

  # GET /apps/1/edit
  def edit
  end

  # POST /apps
  def create

    @app = App.new(app_params)

    if @app.save
      redirect_to @app, notice: 'App was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /apps/1
  def update
    if @app.update(app_params)
      redirect_to @app, notice: 'App was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /apps/1
  def destroy
    # TODO: use cancan to check ability
    @app.destroy
    redirect_to apps_url, notice: 'App was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def app_params
      params.require(:app).permit(:name, :identifier, :key, :app_type, :url, :group_id)
    end
end

class AppTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_type, only: [:show, :edit, :update, :destroy]

  # GET /app_types
  def index
    @app_types = AppType.all
  end

  # GET /app_types/1
  def show
  end

  # GET /app_types/new
  def new
    @app_type = AppType.new
  end

  # GET /app_types/1/edit
  def edit
  end

  # POST /app_types
  def create
    @app_type = AppType.new(app_type_params)

    if @app_type.save
      redirect_to @app_type, notice: 'App type was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /app_types/1
  def update
    if @app_type.update(app_type_params)
      redirect_to @app_type, notice: 'App type was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /app_types/1
  def destroy
    @app_type.destroy
    redirect_to app_types_url, notice: 'App type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_type
      @app_type = AppType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def app_type_params
      params.require(:app_type).permit(:name)
    end
end

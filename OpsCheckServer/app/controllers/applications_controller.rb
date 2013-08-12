class ApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application, only: [:show, :edit, :update, :destroy]

  # GET /applications
  def index
    @applications = Application.all
  end

  # GET /applications/1
  def show
  end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications
  def create
    @application = Application.new(application_params)
    @application.user = current_user

    if @application.save
      redirect_to @application, notice: 'Application was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /applications/1
  def update
    if @application.update(application_params)
      redirect_to @application, notice: 'Application was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /applications/1
  def destroy
    @application.destroy
    redirect_to applications_url, notice: 'Application was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def application_params
      params.require(:application).permit(:name, :identifier, :app_type_id)
    end
end

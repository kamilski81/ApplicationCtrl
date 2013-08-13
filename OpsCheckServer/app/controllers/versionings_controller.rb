class VersioningsController < ApplicationController
  before_action :authenticate_user!, except: [:check]
  before_action :set_versioning, only: [:show, :edit, :update, :destroy]


  # GET /versionings
  def index
    @versionings = Versioning.all
  end

  # GET /versionings/1
  def show
  end

  # GET /versionings/new
  def new
    @versioning = Versioning.new
  end

  # GET /versionings/1/edit
  def edit
  end

  # POST /versionings
  def create
    @versioning = Versioning.new(versioning_params)

    if @versioning.save
      redirect_to @versioning, notice: 'Versioning was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /versionings/1
  def update
    if @versioning.update(versioning_params)
      redirect_to @versioning, notice: 'Versioning was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /versionings/1
  def destroy
    @versioning.destroy
    redirect_to versionings_url, notice: 'Versioning was successfully destroyed.'
  end


  # HEADERS['version']


  # GET /versionings/check
  def check

    header = 'CONNECT'

    app_key = params[:app_key]
    version = params[:version]
    build = params[:build]

    if app_key.nil? || version.nil? || build.nil?
      response.headers['Version-check'] = ''
      render layout: false, status: :bad_request  # URL is not well formed
    else
      application = App.where(key: app_key).first
      if application.nil?
        @body = "No application found with the following app key #{app_key}"
        response.headers['Version-check'] = ''
        render layout: false, status: :unauthorized    # no app key found
      else
        versioning = Versioning.where(app_id: application.id).first
        if versioning.nil?
          versioning = Versioning.create(versioning_params)
          versioning.status = 1
          versioning.app = application

          if versioning.save == false
            header = "DON'T CONNECT"
            @body = 'Not able to save the current version information into the db!'
          end

        else
          if versioning.status == 0
            @body = 'Your current application version is outdated. Please update it!'
            header = "DON'T CONNECT"
          end

        end

        response.headers['Version-check'] = header
        render layout: false
      end

    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_versioning
      @versioning = Versioning.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def versioning_params
      params.require(:versioning).permit(:version, :build, :status, :app_id)
    end
end

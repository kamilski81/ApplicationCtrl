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
    version_check_header =  'Version-Check'
    app_key = params[:app_key]
    version = params[:version]
    build = params[:build]
    response_format = params[:format] || :html

    response.header[version_check_header] = ''
    status = :bad_request

    @application = App.none
    @body = 'Please review the query parameters. Mandatory params: app_key, version, build. Optional: format'

    if (not app_key.nil?) && (not version.nil?) && (not build.nil?)
      @application = App.where(key: app_key).first

      if @application.nil?
        @application = App.none
        @body = "No application found with the following app key #{app_key}"
        status = :unauthorized    # no app key found
      else
        versioning = Versioning.where(app_id: @application.id).first
        if versioning.nil?
          versioning = Versioning.create(versioning_params)
          versioning.status = 1
          versioning.app = @application

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

        response.headers[version_check_header] = header
      end
    end

    if response_format == :html
      render layout: 'versioning', status: status  # URL is not well formed
    else
      render text: @body
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

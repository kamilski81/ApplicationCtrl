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
    body = ''

    app_key = params[:app_key]

    if not app_key.nil?

      application = App.where(key: app_key).first
      if application.nil?
        body = "No application found with the following app key #{app_key}"
      else
        versioning = Versioning.where(app_id: application.id).first
        if versioning.nil?
          versioning = Versioning.create(versioning_params)
          versioning.status = 1
          versioning.app = application

          if versioning.save == false
            header = "DON'T CONNECT"
          end

        else
          if versioning.status == 0
            header = 'ERROR'
          end

        end
      end

    else
      header = 'ERROR'
      body = 'No app key provided!'
    end

    response.headers['Version-check'] = header
    render text: body
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

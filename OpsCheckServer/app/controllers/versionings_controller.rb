class VersioningsController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :set_versioning, only: [:show, :edit, :update, :destroy]

  protect_from_forgery except: :create


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

    if user_signed_in?
      @versioning = Versioning.new(versioning_params)

      if @versioning.save
        redirect_to @versioning, notice: 'Versioning was successfully created.'
      else
        render action: 'new'
      end
    else
      app_key = params['app_key']
      #check for the api key
      application = App.where(key: app_key).first

      @result = {
          error: nil,
          code: 0,
          versioning_status: nil
      }
      code = 0
      if not application.nil?

        versioning = Versioning.where(app_id: application.id).first

        if versioning.nil?
          code = 2 # we need to create a new entry
          versioning = Versioning.new(versioning_params)
          versioning.status = 1
          versioning.app = application


          if versioning.save
            @result.merge!({versioning_status: versioning.status, code: code})
          else
            @result.merge!({error: 'Not able to create a new versioning entry', code: code})
          end
        else
          code = 1 # we are fetching the entry from the db
          @result.merge!({versioning_status: versioning.status, code: code})
        end
      else
        code = -1
        @result.merge!({error: 'The application does not exist', code: code})
      end

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

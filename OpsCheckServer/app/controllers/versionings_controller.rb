class VersioningsController < ApplicationController
  before_action :authenticate_user!, except: [:create]
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
    if user_signed_in? # check if user is currently logged in because we are not using devise to check this path
      @versioning = Versioning.new(versioning_params)
    else # check for application token

    end

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_versioning
      @versioning = Versioning.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def versioning_params
      params.require(:versioning).permit(:version, :text, :status, :references)
    end
end

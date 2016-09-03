class ResapumdsController < ApplicationController
  before_action :set_resapumd, only: [:show, :edit, :update, :destroy]

  # GET /resapumds
  # GET /resapumds.json
  def index
    @resapumds = Resapumd.all
  end

  # GET /resapumds/1
  # GET /resapumds/1.json
  def show
  end

  # GET /resapumds/new
  def new
    @resapumd = Resapumd.new
  end

  # GET /resapumds/1/edit
  def edit
  end

  # POST /resapumds
  # POST /resapumds.json
  def create
    @resapumd = Resapumd.new(resapumd_params)

    respond_to do |format|
      if @resapumd.save
        format.html { redirect_to @resapumd, notice: 'Resapumd was successfully created.' }
        format.json { render :show, status: :created, location: @resapumd }
      else
        format.html { render :new }
        format.json { render json: @resapumd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resapumds/1
  # PATCH/PUT /resapumds/1.json
  def update
    respond_to do |format|
      if @resapumd.update(resapumd_params)
        format.html { redirect_to @resapumd, notice: 'Resapumd was successfully updated.' }
        format.json { render :show, status: :ok, location: @resapumd }
      else
        format.html { render :edit }
        format.json { render json: @resapumd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resapumds/1
  # DELETE /resapumds/1.json
  def destroy
    @resapumd.destroy
    respond_to do |format|
      format.html { redirect_to resapumds_url, notice: 'Resapumd was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resapumd
      @resapumd = Resapumd.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resapumd_params
      params.require(:resapumd).permit(:trajet_id, :drive1_ref, :drive2_ref, :drive3_ref, :drive4_ref, :drive5_ref, :drive6_ref, :drive1_size, :drive2_size, :drive3_size, :drive4_size, :drive5_size, :drive6_size, :drive1_userid, :drive2_userid, :drive3_userid, :drive4_userid, :drive5_userid, :drive6_userid)
    end
end

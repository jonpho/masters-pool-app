class GolfersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_golfer, only: %i[ show edit update destroy ]
  helper_method :flight_groups
  before_action :authenticate_user!

  # GET /golfers or /golfers.json
  def index
    @golfers = Golfer.all.sort_by do |golfer|
      if golfer.world_ranking == "Unranked"
        golfer.world_ranking = 200
      elsif golfer.world_ranking == "Amateur"
        golfer.world_ranking = 300
      else
        golfer.world_ranking.to_i
      end
    end
  end

  # GET /golfers/1 or /golfers/1.json
  def show
  end

  # GET /golfers/new
  def new
    @golfer = Golfer.new
  end

  # GET /golfers/1/edit
  def edit
  end

  # POST /golfers or /golfers.json
  def create
    @golfer = Golfer.new(golfer_params)

    respond_to do |format|
      if @golfer.save
        format.html { redirect_to golfer_url(@golfer), notice: "Golfer was successfully created." }
        format.json { render :show, status: :created, location: @golfer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @golfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /golfers/1 or /golfers/1.json
  def update
    respond_to do |format|
      if @golfer.update(golfer_params)
        format.html { redirect_to golfer_url(@golfer), notice: "Golfer was successfully updated." }
        format.json { render :show, status: :ok, location: @golfer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @golfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /golfers/1 or /golfers/1.json
  def destroy
    @golfer.destroy

    respond_to do |format|
      format.html { redirect_to golfers_url, notice: "Golfer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def flight_groups(id)
    id == nil ? "" : Flight.find_by(id: id).name
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_golfer
    @golfer = Golfer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def golfer_params
    params.require(:golfer).permit(:player_id, :name, :world_ranking, :flight_ids)
  end
end

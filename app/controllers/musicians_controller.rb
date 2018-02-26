class MusiciansController < ApplicationController
  before_action :set_musician, only: [:show, :edit, :update, :destroy]

  def index
    @musicians = Musician.all

    respond_to do |format|
      format.html
      format.v1_json { render formats: :json }
    end
  end

  def show
    if current_user
      @review = current_user.reviews.find_by(reviewable: @musician)
    end

    respond_to do |format|
      format.html
      format.v1_json { render formats: :json }
    end
  end

  def new
    @musician = Musician.new
  end

  def create
    @musician = Musician.new(musician_params)

    if @musician.save
      respond_to do |format|
        format.html { redirect_to @musician, notice: "#{@musician.name}を登録しました" }
        format.v1_json { render :show, formats: :json, status: :created }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = '登録できませんでした'
          render :new
        }

        format.v1_json { render_invalid_parameters_error(@musician) }
      end
    end
  end

  def edit
  end

  def update
    if @musician.update(musician_params)
      respond_to do |format|
        format.html { redirect_to @musician, notice: "#{@musician.name}を更新しました" }
        format.v1_json { render :show, formats: :json }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = '更新できませんでした'
          render :edit
        }

        format.v1_json { render_invalid_parameters_error(@musician) }
      end
    end
  end

  def destroy
    @musician.destroy!

    respond_to do |format|
      format.html { redirect_to musicians_path, notice: "#{@musician.name}を削除しました" }
      format.v1_json { head :no_content }
    end
  end

  private

  def musician_params
    params.require(:musician).permit(:name, :begun_in, :description)
  end

  def set_musician
    @musician = Musician.includes(reviews: [:user]).find(params[:id])
  end

  def render_invalid_parameters_error(object)
    render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
  end
end

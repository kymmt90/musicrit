class GenresController < ApplicationController
  before_action :set_genre, only: [:show, :edit, :update, :destroy]

  def index
    @genres = Genre.all
  end

  def show
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to genre_path(@genre), notice: "ジャンル#{@genre.name}を登録しました"
    else
      flash.now[:error] = '登録できませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to genre_path(@genre), notice: "ジャンル#{@genre.name}を更新しました"
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @genre.destroy!
    redirect_to genres_path, notice: "ジャンル#{@genre.name}を削除しました"
  end

  private

  def genre_params
    params.require(:genre).permit(:name, :description)
  end

  def set_genre
    @genre = Genre.find(params[:id])
  end
end

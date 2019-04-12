class Admin::WordsController < ApplicationController
  #before_action :set_word, only: [:show, :edit, :update, :destroy]
  # GET /words
  # GET /words.json
  def index
    @words = Word.all.paginate(page: params[:page], :per_page => 15)
  end

  # GET /words/1
  # GET /words/1.json
  def show
    @word = Word.find(params[:id])
    @words = Word.all.paginate(page: params[:page], :per_page => 15)
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
    @word = Word.find(params[:id])
 
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to admin_words_path, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to admin_words_path, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word = Word.find(params[:id])
    @word.destroy
    respond_to do |format|
      format.html { redirect_to admin_words_path, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
        params.require(:word).permit(:word, :meaning, :word_class, :image)
    end
end
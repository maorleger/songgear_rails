# frozen_string_literal: true

class MusiciansController < ApplicationController
  before_action :set_musician, only: [:show, :edit, :update, :destroy]

  # GET /musicians
  # GET /musicians.json
  def index
    @musicians = Musician.all
  end

  # GET /musicians/1
  # GET /musicians/1.json
  def show
  end

  # GET /musicians/new
  def new
    @musician = Musician.new
  end

  # GET /musicians/1/edit
  def edit
  end

  # POST /musicians
  # POST /musicians.json
  def create
    @musician = Musician.new(musician_params)

    respond_to do |format|
      if @musician.save
        format.html { redirect_to @musician, notice: "Musician was successfully created." }
        format.json { render :show, status: :created, location: @musician }
      else
        format.html { render :new }
        format.json { render json: @musician.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /musicians/1
  # PATCH/PUT /musicians/1.json
  def update
    respond_to do |format|
      if @musician.update(musician_params)
        format.html { redirect_to @musician, notice: "Musician was successfully updated." }
        format.json { render :show, status: :ok, location: @musician }
      else
        format.html { render :edit }
        format.json { render json: @musician.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musicians/1
  # DELETE /musicians/1.json
  def destroy
    @musician.destroy
    respond_to do |format|
      format.html { redirect_to musicians_url, notice: "Musician was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_musician
      @musician = Musician.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def musician_params
      params.require(:musician).permit(:name)
    end
end

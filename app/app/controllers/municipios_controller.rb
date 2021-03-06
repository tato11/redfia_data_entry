class MunicipiosController < ApplicationController
  before_action :authenticate_user!
  before_action :load_status, only: [:show, :edit, :update, :new, :create]
  before_action :load_departamento, only: [:edit, :update, :new, :create]
  before_action :set_municipio, only: [:show, :edit, :update, :destroy]
  before_action :load_config
  before_action :config_audit, only: [:create, :update, :destroy]

  # GET /municipios
  # GET /municipios.json
  def index
    @municipios = Municipio.search.page params[:page]
  end

  # GET /municipios/1
  # GET /municipios/1.json
  def show
  end

  # GET /municipios/new
  def new
    @municipio = Municipio.new
  end

  # GET /municipios/1/edit
  def edit
  end

  # POST /municipios
  # POST /municipios.json
  def create
    ActiveRecord::Base.transaction do
      @municipio = Municipio.new(municipio_params)

      respond_to do |format|
        if @municipio.save
          format.html { redirect_to @municipio, notice: 'El Municipio se cre&oacute; exitosamente.' }
          format.json { render :show, status: :created, location: @municipio }
        else
          format.html { render :new }
          format.json { render json: @municipio.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /municipios/1
  # PATCH/PUT /municipios/1.json
  def update
    ActiveRecord::Base.transaction do
      respond_to do |format|
        if @municipio.update(municipio_params)
          format.html { redirect_to @municipio, notice: 'El Municipio se actualizo correctamente.' }
          format.json { render :show, status: :ok, location: @municipio }
        else
          format.html { render :edit }
          format.json { render json: @municipio.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /municipios/1
  # DELETE /municipios/1.json
  def destroy
    ActiveRecord::Base.transaction do
      @municipio.status = Status.find(Status::VALUES[:deleted])
      @municipio.save validate: false
      respond_to do |format|
        format.html { redirect_to municipios_url, notice: 'El Municipio se marco como borrado.' }
        format.json { head :no_content }
      end
    end
  end

  def autocomplete
    query = params[:term]
    search_expression = convert_to_search_expression query
    limit = APP_CONFIG['autocomplete_limit']
    @collection = []
    unless search_expression.blank?
      @collection = Municipio.search(query).limit(limit).order(:nombre)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_municipio
      @municipio = Municipio.find(params[:id])
    end

    def load_status
      @statuses = Status.user_visible
    end

    def load_departamento
      @departamentos = Departamento.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def municipio_params
      params.require(:municipio).permit(:id_departamento, :nombre, :id_status)
    end

    def load_config
      @search_type = [Municipio.search_entity_class]
    end
end

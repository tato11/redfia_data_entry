class TipoDocumentosController < ApplicationController
  before_action :authenticate_user!
  before_action :load_status, only: [:show, :edit, :update, :new, :create]
  before_action :set_tipo_documento, only: [:show, :edit, :update, :destroy]
  before_action :load_config
  before_action :config_audit, only: [:create, :update, :destroy]

  # GET /tipo_documentos
  # GET /tipo_documentos.json
  def index
    @tipo_documentos = TipoDocumento.search.page params[:page]
  end

  # GET /tipo_documentos/1
  # GET /tipo_documentos/1.json
  def show
  end

  # GET /tipo_documentos/new
  def new
    @tipo_documento = TipoDocumento.new
  end

  # GET /tipo_documentos/1/edit
  def edit
  end

  # POST /tipo_documentos
  # POST /tipo_documentos.json
  def create
    ActiveRecord::Base.transaction do
      @tipo_documento = TipoDocumento.new(tipo_documento_params)

      respond_to do |format|
        if @tipo_documento.save
          format.html { redirect_to @tipo_documento, notice: 'El Tipo documento se cre&oacute; exitosamente.' }
          format.json { render :show, status: :created, location: @tipo_documento }
        else
          format.html { render :new }
          format.json { render json: @tipo_documento.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /tipo_documentos/1
  # PATCH/PUT /tipo_documentos/1.json
  def update
    ActiveRecord::Base.transaction do
      respond_to do |format|
        if @tipo_documento.update(tipo_documento_params)
          format.html { redirect_to @tipo_documento, notice: 'El Tipo documento se actualizo correctamente.' }
          format.json { render :show, status: :ok, location: @tipo_documento }
        else
          format.html { render :edit }
          format.json { render json: @tipo_documento.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tipo_documentos/1
  # DELETE /tipo_documentos/1.json
  def destroy
    ActiveRecord::Base.transaction do
      @tipo_documento.status = Status.find(Status::VALUES[:deleted])
      @tipo_documento.save validate: false
      respond_to do |format|
        format.html { redirect_to tipo_documentos_url, notice: 'El Tipo documento se marco como borrado.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_documento
      @tipo_documento = TipoDocumento.find(params[:id])
    end

    def load_status
      @statuses = Status.user_visible
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_documento_params
      params.require(:tipo_documento).permit(:nombre, :descripcion, :id_status)
    end

    def load_config
      @search_type = [TipoDocumento.search_entity_class]
    end
end

class Investigacion < ApplicationRecord
  self.table_name = 'investigaciones'

  belongs_to :status, class_name: 'Status', foreign_key: 'id_status'
  belongs_to :facultad, class_name: 'Facultad', foreign_key: 'id_instituto', inverse_of: :investigaciones
  belongs_to :municipio, class_name: 'Municipio', foreign_key: 'id_municipio', inverse_of: :investigaciones
  belongs_to :microcuenca, class_name: 'Microcuenca', foreign_key: 'id_microcuenca', inverse_of: :investigaciones
  belongs_to :tipo_documento, class_name: 'TipoDocumento', foreign_key: 'id_documento', inverse_of: :investigaciones
  has_and_belongs_to_many :areas,
    class_name: "Area",
    foreign_key: "id_investigacion",
    association_foreign_key: "id_area",
    join_table: 'area_investigacion'

  class << self
    def search_entity_class parent = nil
      value = self.name
      value = "#{value}#{self::SEARCH_JOIN_TOKEN}#{parent}" if !parent.blank?
      value
    end

    def search query, opts = {}
      parent = opts.delete(:parent)
      results = self
      results = where(facultad: parent) if !parent.blank?
      results.where("titulo RLIKE ?", [query])
        .includes(
          :status,
          :facultad,
          {municipio: [:departamento]},
          :microcuenca,
          :tipo_documento
        )
        .order(:titulo)
    end
  end
end

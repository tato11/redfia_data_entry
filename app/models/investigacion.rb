class Investigacion < ApplicationRecord
  self.table_name = 'Investigaciones'

  belongs_to :status, class_name: 'Status', foreign_key: 'id_status'
  belongs_to :facultad, class_name: 'Facultad', foreign_key: 'id_insituto', inverse_of: :investigaciones
  belongs_to :municipio, class_name: 'Municipio', foreign_key: 'id_municipio', inverse_of: :investigaciones
  belongs_to :microcuenca, class_name: 'Microcuenca', foreign_key: 'id_microcuenca', inverse_of: :investigaciones
  belongs_to :tipo_documento, class_name: 'TipoDocumento', foreign_key: 'id_documento', inverse_of: :investigaciones
  has_and_belongs_to_many :areas,
    class_name: "Area",
    foreign_key: "id_investigacion",
    association_foreign_key: "id_area",
    join_table: 'area_investigacion'
end
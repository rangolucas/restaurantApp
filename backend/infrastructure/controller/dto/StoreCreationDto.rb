class StoreCreationDto
  attr_reader :coordinates, :name, :time_table, :contact_info, :logo

  def initialize(coordinates, name, time_table, contact_info, logo)
    @coordinates = coordinates
    @name = name
    @time_table = time_table
    @contact_info = contact_info
    @logo = logo
  end
end
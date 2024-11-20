class StoreCreationDto
  attr_reader :coordinates, :name, :address, :time_table, :contact_info, :logo

  def initialize(coordinates, name, address, time_table, contact_info, logo)
    @coordinates = coordinates
    @name = name
    @address = address
    @time_table = time_table
    @contact_info = contact_info
    @logo = logo
  end
end
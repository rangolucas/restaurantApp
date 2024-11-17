class StoreCreationDto
  attr_reader :coordinates, :name, :time_table, :contact_info

  def initialize(coordinates, name, time_table, contact_info)
    @coordinates = coordinates
    @name = name
    @time_table = time_table
    @contact_info = contact_info
  end
end
class StoreCreationDto
  attr_reader :coordinates, :time_table, :contact_info

  def initialize(coordinates, time_table, contact_info)
    @coordinates = coordinates
    @time_table = time_table
    @contact_info = contact_info
  end
end
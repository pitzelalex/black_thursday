class GeneralRepo

  attr_reader :repository

  def initialize(data = {})
    @repository = []
    data.each { |general| create(general) }
  end

  def all
    @repository
  end

  def find_by_id(id)
    @repository.find { |general| general.id == id.to_s }
  end

  def create(general_data)
    general_data[:id] ||= (@repository.last.id.to_i + 1).to_s
    general = General.new(general_data)
    @repository << general
    general
  end

  def update(id, attribute_data)
    find_by_id(id).update(attribute_data)
  end

  def delete(id)
    @repository.delete(find_by_id(id))
  end
end


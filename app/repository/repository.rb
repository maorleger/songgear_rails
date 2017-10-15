# frozen_string_literal: true

class Repository
  def initialize(model)
    @model = model
  end

  def all
    model.all
  end

  def get(id)
    model.find_by_id(id)
  end

  def create(params)
    model.create(params)
  end

  private
    attr_reader :model
end

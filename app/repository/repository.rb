# frozen_string_literal: true

class Repository
  def initialize(model)
    @model = model
  end

  def all
    model.all
  end

  def get(id)
    model.find(id)
  end

  def create(params)
    model.create(params)
  end

  def update(object, params)
    object.tap do |o|
      o.update(params)
    end
  end

  private
    attr_reader :model
end

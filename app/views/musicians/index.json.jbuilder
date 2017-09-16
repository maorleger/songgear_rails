# frozen_string_literal: true

json.array! @musicians, partial: "musicians/musician", as: :musician

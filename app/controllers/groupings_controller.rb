class GroupingsController < ApplicationController
  def index
    @groupings = Grouping.all
  end
end

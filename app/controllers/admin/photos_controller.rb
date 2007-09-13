class Admin::PhotosController < PhotosController

  acts_as_administration

  def self.controller_path
    PhotosController.controller_path
  end


end

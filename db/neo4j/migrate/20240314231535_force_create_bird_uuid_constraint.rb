class ForceCreateBirdUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Bird, :uuid, force: true
  end

  def down
    drop_constraint :Bird, :uuid
  end
end

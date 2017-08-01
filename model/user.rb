module MPP
  class User < Diva::Model
    include Diva::Model::UserMixin

    field.string :name, required: true
    field.string :idname, required: true
    field.has :icon, Diva::Model
  end
end

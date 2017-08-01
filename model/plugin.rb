require_relative 'user'

module MPP
  class Plugin < Diva::Model
    include Diva::Model::MessageMixin

    register :mpp_plugin, name: 'MPP Plugin', timeline: true, myself: false

    field.string :name, required: true
    field.string :description, required: true
    field.has :user, MPP::User
    field.time :created
    field.time :modified
  end
end

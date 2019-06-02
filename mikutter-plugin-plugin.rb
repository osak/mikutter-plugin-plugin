require_relative 'model/plugin'
require_relative 'model/user'

Plugin.create(:mikutter_plugin_plugin) do
  tab :mpp_plugins do
    tl = timeline :mpp_plugins
    Plugin.instances.sort_by{|pl| pl.name}.reverse_each do |pl|
      spec = pl.spec || {}
      author = spec[:author] || 'Unknown'
      tl << MPP::Plugin.new(
          name: pl.name,
          description: "#{pl.name}\n#{spec[:description]}",
          created: pl.defined_time,
          modified: (Time.now.to_f * 1000000).to_i,
          user: MPP::User.new(
              name: pl.name,
              idname: pl.name,
              icon: Skin['icon.png']
          )
      )
    end
  end

  command(:mpp_open_setting,
          name: '設定',
          condition: lambda{|opt|
            opt.messages.size == 1 &&
                opt.messages.first.is_a?(MPP::Plugin) &&
                find_setting_spec(opt.messages.first.name.to_sym)
          },
          visible: true,
          role: :timeline) do |opt|
    plugin_name = opt.messages.first.name.to_sym
    plugin = Plugin.instances.find{|pl| pl.name == plugin_name}
    setting_spec = find_setting_spec(plugin_name)
    dialog("Setting #{plugin_name}") {
      scrolled = ::Gtk::ScrolledWindow.new.set_hscrollbar_policy(::Gtk::POLICY_NEVER)
      pane = scrolled.add_with_viewport(Plugin::Settings::SettingDSL.new(plugin, &setting_spec[1]))
      pack_start pane
    }.next{
      puts "ok"
    }.trap{
      puts "cancel"
    }
  end

  def find_setting_spec(name)
    Plugin.filtering(:defined_settings, []).first.find{|s| s[2] == name}
  end
end

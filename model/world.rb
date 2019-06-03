module MPP
  class World < Diva::Model
    Command = Struct.new(:name, :args)

    field.string :title, required: true
    field.string :slug, required: true
    register :mikutter_plugin_plugin, name: "Mikutter Plugin Plugin World"

    def initialize(**kwargs)
      hash = {
          title: 'Mikutter Plugin Plugin',
          slug: :mikutter_plugin_plugin,

      }.merge(kwargs)
      super(hash)
    end

    def icon
      Skin['icon.png']
    end

    def run_command_line(line)
      cmd = parse_command_line(line)
      return if cmd.nil?

      puts cmd
    end

    private

    # コマンド文字列をパースする。
    # ==== Args
    # [line] パースしたい文字列
    # ==== Return
    # Commandオブジェクト。lineがコマンド文字列でなかった場合はnil
    def parse_command_line(line)
      m = line.match(%r{^\s*/(?<command>\w+)\s+(?<args>.*)$})
      return nil if !m

      Command.new(m[:command], m[:args])
    end
  end
end

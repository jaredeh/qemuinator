require 'yaml'

config = YAML.load_file("config/defaults.yaml")

def make_cmdline(config,qarch)
  cmd  = config['qemubinary'] + qarch['arch']
  if qarch['qemu'] == nil then raise "you need a qemu section" end
  q = qarch['qemu']
  if q['params'] == nil then raise "qemu section needs params" end
  c = q['params']
  c.keys.each do |key|
    cmd += " -#{key} #{c[key]}"
  end
  if q['redir'] == true
    cmd += " -redir tcp:#{qarch['port']}::22"
  end
  if q['append'] != nil
    cmd += " -append \""
    append = []
    q['append'].keys.each do |key|
      a = "#{key}"
      if q['append'][key] != nil
        a += "=#{q['append'][key]}"
      end
      append.push a
    end
    cmd += append.join(" ")
    cmd += "\""
  end
  puts cmd
end

task :mkcmds do
  cmdlines = YAML.load_file("config/qemu.yaml")
  puts cmdlines
  cmdlines.each {|c| make_cmdline(config,c)}
end

task :default do
  puts "pbbt!"
end
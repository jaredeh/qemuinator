require 'yaml'

def get_config()
  config = YAML.load_file("config/defaults.yaml")
  config.merge!(YAML.load_file("config/systems.yaml"))
  config['machines'] = YAML.load_file("config/machines.yaml")

  config['yocto_path'] = File.join(config['root_path'], config['yocto_path'])
  config['backup_path'] = File.join(config['root_path'], config['backup_path'])
  config['machines_path'] = File.join(config['root_path'], config['machines_path'])
  config['yocto_qemubinary'] = File.join(config['yocto_path'], config['yocto_qemubinary'])
  return config
end

config = get_config()

def make_cmdline(config,qarch)
  cmd  = config['yocto_qemubinary'] + qarch['arch']
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

task :download_qemu_systems_files do
  config['systems'].keys.each do |sys|
    system_backup = File.join(config['backup_path'],sys)
    sh "mkdir -p #{system_backup}"
    config['systems'][sys]['files'].each do |url|
      file = url.split('/')[-1]
      if not File.exists?(File.join(system_backup,file))
        sh "wget -P #{system_backup} #{url}"
      end
    end
  end
end

task :build_machine do
  config['machines'].each do |vm|
    vm.merge!(config['systems'][vm['system']])
    vmpath = File.join(config['machines_path'], vm['name'])
    sh "mkdir -p #{vmpath}"
    vm['files'].each do |url|
      file = url.split('/')[-1]
      src = File.join(config['backup_path'], vm['system'], file)
      dst = File.join(File.join(vmpath, file)
      if not File.exists?(dst)
        cp src, dst
      end
      cmdline = make_cmdline(config,vm)
      script = File.join(vmpath,"go.sh")
      File.open(script, 'w') {|f| f.write(cmdline) }
      sh "chmod +x #{script}"
    end
  end
end

task :build_yocto_qemu_binaries do
  scriptpath = File.join(File.dirname(__FILE__),"config", "build_yocto_qemu.sh")
  sh "cd #{config['yocto_path']}; #{scriptpath} #{config['yocto_path']}"
end

task :make_directories do
  ['root_path', 'yocto_path', 'backup_path', 'machines_path'].each do |f|
    path = config[f]
    sh "sudo mkdir -p #{path}"
    sh "sudo chmod a+w #{path}"
  end
end

task :prep_host do
  if `uname -a |grep Ubuntu`
    scriptpath = File.join(File.dirname(__FILE__),"config", "prep_ubuntu.sh")
    sh "sudo #{scriptpath}"
  else
    raise "host os not supported"
  end
end

task :install => [:make_directories, :prep_host, :build_yocto_qemu_binaries, :download_qemu_systems_files, :build_machine]

task :start do
end

task :default do
  puts "pbbt!"
  puts config
end
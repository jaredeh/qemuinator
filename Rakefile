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
  return cmd
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
      dst = File.join(File.join(vmpath, file))
      if not File.exists?(dst)
        cp src, dst
      end
      cmdline = make_cmdline(config,vm)
      script = File.join(vmpath,"launch_vm.sh")
      File.open(script, 'w') do |f|
        f.write("cd $1; ")
        f.write(cmdline)
      end
      sh "chmod +x #{script}"
    end
  end
end

task :build_yocto_qemu_binaries do
  if not File.exist?(config['yocto_qemubinary'] + "i386")
    scriptpath = File.join(File.dirname(__FILE__),"config", "build_yocto_qemu.sh")
    sh "cd #{config['yocto_path']}; #{scriptpath} #{config['yocto_path']}"
  end
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

task :clone do
  sh "cp -r .git #{config['root_path']}"
  sh "cd #{config['root_path']}; git checkout -f"
end

task :debian_jenkins_deps do
  require 'net/ssh'
  scriptpath = File.join(File.dirname(__FILE__),"config", "wheezy_jenkins_deps.sh")
  fdata = File.read(scriptpath)
  keypath = File.join(File.dirname(__FILE__),"config", "id_rsa.pub")
  kdata = File.read(keypath)
  config['machines'].each do |vm|
    Net::SSH.start( 'localhost', 'root', :password => 'root', :port => vm['port'] ) do |ssh|
      puts ssh.exec!(fdata)
    end
    Net::SSH.start( 'localhost', 'user', :password => 'user', :port => vm['port'] ) do |ssh|
      puts ssh.exec!("mkdir -p ~/.ssh")
      puts ssh.exec!("echo \"#{kdata}\" >> ~/.ssh/authorized_keys")
      puts ssh.exec!("chmod 700 ~/.ssh && chmod 600 ~/.ssh/*")
    end
  end
end

task :install => [:make_directories, :prep_host, :build_yocto_qemu_binaries, :download_qemu_systems_files, :build_machine, :clone]

task :start do
  Dir.foreach(config['machines_path']) do |machine|
    if ['.','..'].include?(machine) then next end
    machine_path = File.join(config['machines_path'],machine)
    if not File.directory?(machine_path) then next end
    sh "screen -S #{machine} -d -m  #{machine_path}/launch_vm.sh #{machine_path}"
  end
end

task :default do
  puts "pbbt!"
  puts config
end
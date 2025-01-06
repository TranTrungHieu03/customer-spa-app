def install_all_flutter_pods(flutter_application_path)
  flutter_install_ios_engine_pod(flutter_application_path)
  flutter_install_plugin_pods(flutter_application_path)
end

def flutter_install_ios_engine_pod(flutter_application_path)
  pod 'Flutter', :path => File.join(flutter_application_path, 'bin', 'cache', 'artifacts', 'engine', 'ios')
end

def flutter_install_plugin_pods(flutter_application_path)
  plugin_pods = parse_KV_file(File.join(flutter_application_path, '.flutter-plugins'))
  plugin_pods.each do |name, path|
    pod name, :path => path
  end
end

def parse_KV_file(file)
  file_contents = File.read(file)
  plugin_pods = {}
  file_contents.split("\n").each do |line|
    next if line.empty?
    key, value = line.split('=')
    plugin_pods[key] = value
  end
  plugin_pods
end
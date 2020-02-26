Pod::Spec.new do |spec|
  spec.name = 'Fugen'
  spec.version = `make version`
  spec.summary = 'Swift code & resources generator for your Figma files.'

  spec.homepage = 'https://github.com/almazrafi/Fugen'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Almaz Ibragimov' => 'almazrafi@gmail.com' }

  spec.source = {
    http: "https://github.com/almazrafi/Fugen/releases/download/#{spec.version}/fugen-#{spec.version}.zip"
  }

  spec.preserve_paths = '*'
  spec.exclude_files = '**/file.zip'
end

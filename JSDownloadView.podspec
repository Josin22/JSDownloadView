Pod::Spec.new do |s|

  s.name         = "JSDownloadView"
  s.version      = "1.0"
  s.summary      = "A download animation view"

  s.description  = <<-DESC
                    A download animation view
                  DESC
  s.homepage     = "https://github.com/Josin22/JSDownloadView"
  s.license      = "MIT"
  s.author       = { "Josin" => "josin.mc@gmail.com" }
  s.source       = { :git => "https://github.com/Josin22/JSDownloadView.git", :tag => s.version  }
 
  s.source_files = "JSDownloadView"
  
  s.ios.deployment_target = '8.0'
  
  s.frameworks  = "Foundation"

  s.requires_arc = true

end

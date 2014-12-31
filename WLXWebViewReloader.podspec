Pod::Spec.new do |s|

  s.name             = "WLXWebViewReloader"
  s.version          = "1.0.2"
  s.summary          = "An extension to WKWebView that reloads the web view when the source changes."
  s.description      = <<-DESC
                       WLXWebViewReloader adds an extension to WKWebView to reload the web view
                       when the sources changes. If you are using a web view to display content
                       that is stored in the app's you know that everytime you make a change to
                       the source files (HTML, JS, CSS) you have to do a clean + build 
                       (cmd + shift + k and cmd + r).

                       WLXWebViewReloader allows you (when you are in dev mode) to instead load
                       the source (HTML, JS, CSS) from a Nodejs server and everytime you change
                       a file the web view will reload automatically.

                       You need to install the webview-reloader-server for this Pod to work.
                       Check to npm module https://github.com/Wolox/webview-reloader-server.
                       DESC
  s.homepage         = "https://github.com/Wolox/WLXWebViewReloader"
  s.license          = 'MIT'
  s.author           = { "Guido Marucci Blas" => "guidomb@wolox.com.ar" }
  s.source           = { :git => "https://github.com/Wolox/WLXWebViewReloader.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.framework = 'WebKit'
  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'WLXWebViewReloader' => ['Pod/Assets/*.png', 'Pod/Assets/*.html', 'Pod/Assets/*.js']
  }

end

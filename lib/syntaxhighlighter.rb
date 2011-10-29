module Redmine
  module SyntaxHighlighting
    module JsSyntaxHighlighter
	  SETTING_KEY_THEME = "JsSyntaxHighlighter Theme"
	  DEFAULT_THEME = "Midnight"
	  THEMES = %w[
	    Default
		Django
		Eclipse
		Emacs
		FadeToGrey
		Midnight
		RDark
	  ]
      
      class << self     
        def highlight_by_filename(text, filename)
			# I don't see a way how to use JavaScript highlighter
			Redmine::SyntaxHighlighting::CodeRay.highlight_by_filename(text, filename)
			#language = File.extname(filename)			
			# "<pre class=\"brush: " + language[1..-1] + "\">" + text.gsub("<", "&lt;") + ""
        end
        
        def highlight_by_language(text, language)
			# TODO how to select by brush class, so we don't need jsh
			"<pre class=\"jsh brush: " + language + "\">" + text.gsub("<", "&lt;") + "</pre>"
			#"</code></pre><pre class=\"brush: " + language + "\">" + text.gsub("<", "&lt;") + "</pre><pre><code>"			
        end
        
        def theme
		  # return user setting for theme
		  user_theme = User.current.custom_value_for(CustomField.first(:conditions => {:name => Redmine::SyntaxHighlighting::JsSyntaxHighlighter::SETTING_KEY_THEME}))
		  user_theme || self::DEFAULT_THEME
        end
      end
      
      class Assets < Redmine::Hook::ViewListener
        def view_layouts_base_html_head(context)
		  # javascript_include_tag("src/shCore.js", :plugin => "redmine_syntaxhighlighter")
		  #js = ""
		  #js << "SyntaxHighlighter.autoloader("
		  #js << "'bash shell     http://alexgorbatchev.com/pub/sh/current/scripts/shBrushBash.js',"
		  #js << "'css     http://alexgorbatchev.com/pub/sh/current/scripts/shBrushCss.js',"
		  #js << "'js jscript javascript     http://alexgorbatchev.com/pub/sh/current/scripts/shBrushJScript.js',"		  
		  #js << "'php     http://alexgorbatchev.com/pub/sh/current/scripts/shBrushPhp.js',"		  		  
          #js << "'xml xhtml xslt html xhtml http://alexgorbatchev.com/pub/sh/current/scripts/shBrushXml.js'"
		  #js << ");"
		  #js = "SyntaxHighlighter.all();"
		  
		  js = "document.observe('dom:loaded', function() {"
		  js << "$$('pre.jsh').each(function(e) { e.up().replace(e); });"
		  js << "SyntaxHighlighter.highlight();"
		  js << "});"

		  o = ""
		  o << javascript_include_tag("http://alexgorbatchev.com/pub/sh/current/scripts/shCore.js")
		  # o << javascript_include_tag("http://alexgorbatchev.com/pub/sh/current/scripts/shAutoloader.js")
		  o << javascript_include_tag("http://alexgorbatchev.com/pub/sh/current/scripts/shBrushXml.js")
		  o << javascript_include_tag("http://alexgorbatchev.com/pub/sh/current/scripts/shBrushJScript.js")		  
		  o << javascript_include_tag("http://alexgorbatchev.com/pub/sh/current/scripts/shBrushPhp.js")		  		  
		  o << javascript_include_tag("http://alexgorbatchev.com/pub/sh/current/scripts/shBrushCss.js")		  		  		  
		  o << javascript_include_tag("http://alexgorbatchev.com/pub/sh/current/scripts/shBrushBash.js")		  		  		  
		  o << stylesheet_link_tag("http://alexgorbatchev.com/pub/sh/current/styles/shCore#{Redmine::SyntaxHighlighting::JsSyntaxHighlighter.theme}.css")
		  o << javascript_tag(js)
		  o
		  #stylesheet_link_tag("styles/shCore.css", :plugin => "redmine_syntaxhighlighter") # not working ?
          #stylesheet_link_tag("javascripts/styles/#{Redmine::SyntaxHighlighting::JsSyntaxHighlighter.theme}", :plugin => "redmine_syntaxhighlighter")		  
        end
      end
    end
  end
end

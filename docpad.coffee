# Require
fsUtil = require('fs')
pathUtil = require('path')

# Prepare
textData =
	heading: "DocPad"
	copyright: '''
		DocPad is a <a href="http://bevry.me" title="Bevry - An open company and community dedicated to empowering developers everywhere.">Bevry</a> creation.
		'''

	linkNames:
		main: "Website"
		learn: "Learn"
		email: "Email"
		twitter: "Twitter"

		support: "Support"
		showcase: "Showcase"

	projectNames:
		docpad: "DocPad"
		node: "Node.js"
		queryengine: "Query Engine"

	categoryNames:
		start: "Getting Started"
		community: "Community"
		core: "Core"
		extend: "Extend"
		handsonnode: "Hands on with Node"
navigationData =
	top:
		'Intro': '/docs/intro'
		'Install': '/docs/install'
		'Start': '/docs/start'
		'Showcase': '/docs/showcase'
		'Plugins': '/docs/plugins'
		'Support': '/docs/support'
		'Documentation': '/docs'

	bottom:
		'DocPad': '/'
		'GitHub': 'https://github.com/docpad/docpad'
		'Support': '/docs/support'
websiteVersion = require('./package.json').version
docpadVersion = require('./package.json').dependencies.docpad.toString().replace('~', '').replace('^', '')
exchangeUrl = "http://helper.docpad.org/exchange.cson?version=#{docpadVersion}"
siteUrl = if process.env.NODE_ENV is 'production' then "http://docpad.org" else "http://localhost:9778"
contributorsGetter = null
contributors = null


# =================================
# Helpers

# Titles
getName = (a,b) ->
	if b is null
		return textData[b] ? humanize(b)
	else
		return textData[a][b] ? humanize(b)
getProjectName = (project) ->
	getName('projectNames',project)
getCategoryName = (category) ->
	getName('categoryNames',category)
getLinkName = (link) ->
	getName('linkNames',link)
getLabelName = (label) ->
	getName('labelNames',label)

# Humanize
humanize = (text) ->
	text ?= ''
	return require('underscore.string').humanize text.replace(/^[\-0-9]+/,'').replace(/\..+/,'')

isWin = process.platform.indexOf('win') is 0
# =================================
# Configuration


# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig =

	# =================================
	# DocPad Configuration

	# Regenerate each day
	regenerateEvery: 1000*60*60*24


	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# -----------------------------
		# Misc

		text: textData
		navigation: navigationData

		# The URL we use to fetch the exchange data, included in template data for debugging
		exchangeUrl: exchangeUrl


		# -----------------------------
		# Site Properties

		site:
			# The production URL of our website
			url: siteUrl

			# The default title of our website
			title: "DocPad - Streamlined Web Development"

			# The website description (for SEO)
			description: """
				Empower your website frontends with layouts, meta-data, pre-processors (markdown, jade, coffeescript, etc.), partials, skeletons, file watching, querying, and an amazing plugin system. Use it either standalone, as a build script, or even as a module in a bigger system. Either way, DocPad will streamline your web development process allowing you to craft full-featured websites quicker than ever before.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				bevry, bevryme, balupton, benjamin lupton, docpad, node, node.js, javascript, coffeescript, query engine, queryengine, backbone.js, cson
				"""

			# Services
			services:
				# ircwebchat: 'docpad'

				# travisStatusButton: 'docpad/docpad'
				furyButton: 'docpad'
				gratipayButton: 'bevry'
				flattrButton: '344188/balupton-on-Flattr'
				paypalButton: 'QB8GQPZAH84N6'

				facebookLikeButton:
					applicationId: '266367676718271'
				twitterTweetButton: 'docpad'
				twitterFollowButton: 'docpad'
				githubStarButton: 'docpad/docpad'

				#disqus: 'docpad'
				#gauges: '50dead2bf5a1f541d7000008'
				googleAnalytics: 'UA-35505181-2'
				#inspectlet: '746529266'
				#mixpanel: 'd0f9b33c0ec921350b5419352028577e'
				#reinvigorate: '89t63-62ne18262h'

			# Styles
			styles: [
                '/styles/layers-min.css'
                '/styles/font-awesome-min.css'
                '/styles/style-dev.css'
				'/styles/extras.css'
				'/styles/extra-responsive.css'
                '/styles/color-mauve.css'
				'/styles/monokai_sublime.css'
			].map (url) -> "#{url}?websiteVersion=#{websiteVersion}"
			.concat(['http://fonts.googleapis.com/css?family=Montserrat:400,700|Open+Sans:400italic,700italic,400,700'])

			# Script
			scripts: [
				# Vendor
				"/vendor/jquery.js"
				#"/vendor/jquery-scrollto.js"
				#"/vendor/modernizr.js"
				#"/vendor/history.js"

				# Scripts
				#"/vendor/historyjsit.js"
				#"/scripts/bevry.js"
				#"/scripts/script.js"
				#"/scripts/wait-for-images.js"
				#"/scripts/modernizr-custom.js"
				#"/scripts/skrollr.js"
				#"/scripts/easy-pie-chart.js"
				#"/scripts/on-screen.js"
				#"/scripts/shuffle.js"
				#"/scripts/fluid-vids.js"
				#"/scripts/image-lightbox.js"
				#"/scripts/count-to.js"
				#"/scripts/all-pages.js"
				"/scripts/all-pages-min.js"
			].map (url) -> "#{url}?websiteVersion=#{websiteVersion}"

		# -----------------------------
		# Helper Functions

		# Names
		getName: getName
		getProjectName: getProjectName
		getCategoryName: getCategoryName
		getLinkName: getLinkName
		getLabelName: getLabelName

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a title, we should use it suffixed by the site's title
			if @document.pageTitle isnt false and @document.title
				"#{@document.pageTitle or @document.title} | #{@site.title}"
			# if we don't have a title, then we should just use the site's title
			else if @document.pageTitle is false or @document.title? is false
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')

		# Get Version
		getVersion: (v,places=1) ->
			return v.split('.')[0...places].join('.')

		# Read File
		readFile: (relativePath) ->
			path = @document.fullDirPath+'/'+relativePath
			result = fsUtil.readFileSync(path)
			if result instanceof Error
				throw result
			else
				return result.toString()

		# Code File
		codeFile: (relativePath,language) ->
			language ?= pathUtil.extname(relativePath).substr(1)
			contents = @readFile(relativePath)
			return """<pre><code class="#{language}">#{contents}</code></pre>"""

		# Get Contributors
		getContributors: -> contributors or []
		
		getPrevNextModels: (document) ->
			docsCollection = @getCollection('docs')
			for item,index in docsCollection.models
				if item.id is @document.id
					break

			prev = docsCollection.models[index-1] ? null
			next = docsCollection.models[index+1] ? null

			return {prev,next}
		
		output: []
		getDocumentationListing: ->
			if @output.length > 0
				return @output
			collection = @getCollection('docs')
			occuredCategories = []
			categories = collection.pluck('category')
			for category in categories
				# Check
				if category != "partners"
					continue  if category in occuredCategories
					occuredCategories.push(category)

					# Category Items
					categoryItems = collection.findAll({category}, {title: 1})
					if category in ["1-start","start"]
						category = "Getting Started"
					category =  category[0].toUpperCase() + category.slice(1)
			
					@output.push({title:category,categoryItems:categoryItems.toJSON()})
			return @output
		
		getLatestEdits: (num) ->
			num = 4 or num
			docs = @getCollection('docs').findAll({},[mtime:1],{limit:4}).toJSON()
			return docs
			
		
		callToAction:
			callText: 'Install DocPad Now?'
			buttonText:'Install'
			buttonUrl: "https://www.npmjs.com/package/docpad"
		
		mockUp:
			title: 'Open Sourced and Community Driven'
			text: 'Built on an open source foundation and supported by community maintained plugins, DocPad is getting better every single day.'
			buttonText: 'Get Started With DocPad'
			buttonUrl: '/docs/start'
			image: 'img/magazine.docpad2.jpg'
			
		counters: [
			{name:'Downloads Per Month',value:14000}
			{name:'DocPad Plugins',value:200,suffix: '+'}
			{name:'Something Else',value:326}
			{name:'Everyday visitor',value:58802}
		]
		
		partners:
			title:'DocPad Partners'
			text: 'Myplanet is a digital product development company based out of Toronto, Canada. They funded the development of DocPad’s <a href="https://github.com/bevry/docpad/issues/500">importer functionality</a>.'
			buttonUrl:'/partners/myplanet'
		
		testimonials: [
			{text:"I like DocPad because it's nice and it makes websites.",author:"Benjamin Lupton",image:"/img/balupton.jpg"}
			{text:"Bob the Builder asked if we could fix it. We said 'Yes we can!'",author:"Bob Builder",image:"/img/bob-builder.jpg"}
			{text:"We are the Borg. Lower your shields and surrender your ships. We will add your biological and technological distinctiveness to our own. Your culture will adapt to service us. Resistance is futile.",author:"The Borg",image:"/img/borg.jpg"}
		]
			

		getPageAnchors: (document) ->
			txt = document.source
			lines = txt.split('\n')
			result = []
			for line in lines
				if line.substr(0,1) == '#'
					line = line.replace(/#/g,'').trim()
					result.push(line)
			return result
		
			
		
		writeObject: (name,obj) ->
			fsUtil.writeFileSync(name,JSON.stringify(obj),'utf-8')
					


	# =================================
	# Collections

	collections:

		# Fetch all documents that exist within the docs directory
		# And give them the following meta data based on their file structure
		# [\-0-9]+#{category}/[\-0-9]+#{name}.extension
		docs: (database) ->
			learn = if isWin then 'learn\\' else 'learn/'
			query =
				write: true
				relativeOutDirPath: $startsWith: learn
				body: $ne: ""
			sorting = [projectDirectory:1, categoryDirectory:1, filename:1]
			database.findAllLive(query, sorting).on 'add', (document) ->
				# Prepare
				a = document.attributes

				###
				learn/#{organisation}/#{project}/#{category}/#{filename}
				###
				pathDetailsExtractor = ///
					^
					.*?learn/
					(.+?)/        # organisation
					(.+?)/        # project
					(.+?)/        # category
					(.+?)\.       # basename
					(.+?)         # extension
					$
				///
				
				#To much of a monster to combine the two regex expressions
				if isWin
					pathDetailsExtractor = ///
						^
						.*?learn\\
						(.+?)\\        # organisation
						(.+?)\\        # project
						(.+?)\\        # category
						(.+?)\.       # basename
						(.+?)         # extension
						$
					///

				pathDetails = pathDetailsExtractor.exec(a.relativePath)

				# Properties
				layout = 'doc'
				standalone = true
				organisationDirectory = organisation = organisationName =
					projectDirectory = project = projectName =
					categoryDirectory = category = categoryName =
					title = pageTitle = null

				# Check if we are correctly structured
				if pathDetails?
					organisationDirectory = pathDetails[1]
					projectDirectory = pathDetails[2]
					categoryDirectory = pathDetails[3]
					basename = pathDetails[4]

					#regex to strip out leading numbers in
					#the form of "01-" for purposes of urls
					p1 = /[\-0-9]+/
					p2 = /^[\-0-9]+/
					organisation = organisationDirectory.replace(p1, '')
					organisationName = humanize(project)

					project = projectDirectory.replace(p1, '')
					projectName = getProjectName(project)

					category = categoryDirectory.replace(p2, '')
					categoryName = getCategoryName(category)

					name = basename.replace(p2,'')

					title = "#{a.title or humanize name}"
					pageTitle = "#{title} | DocPad"  # changed from bevry website

					urls = ["/docs/#{name}", "/docs/#{category}-#{name}", "/docpad/#{name}"]
					if category == 'partners'
						urls = ["/partners/#{name}"].concat(urls)

					githubEditUrl = "https://github.com/#{organisationDirectory}/#{projectDirectory}/edit/master/"
					proseEditUrl = "http://prose.io/##{organisationDirectory}/#{projectDirectory}/edit/master/"
					editUrl = githubEditUrl + a.relativePath.replace("learn/#{organisationDirectory}/#{projectDirectory}/", '')

					# Apply
					document
						.setMetaDefaults({
							layout: 'post'
							standalone

							name
							title
							pageTitle

							url: urls[0]

							editUrl

							organisationDirectory
							organisation
							organisationName

							projectDirectory
							project
							projectName

							categoryDirectory
							category
							categoryName
						})
						.addUrl(urls)

				# Otherwise ignore this document
				else
					console.log "The document #{a.relativePath} was at an invalid path, so has been ignored"
					document.setMetaDefaults({
						ignore: true
						render: false
						write: false
					})

		partners: (database) ->
			database.findAllLive({relativeOutDirPath:'learn/docpad/documentation/partners'}, [filename:1]).on 'add', (document) ->
				document.setMetaDefaults(write: false)


	# =================================
	# Plugins

	# Alias stylus highlighting to css and there is no inbuilt stylus support
	plugins:
		highlightjs:
			aliases:
				stylus: 'css'
				shell: 'ps'

		feedr:
			feeds:
				latestPackage:
					url: "http://helper.docpad.org/latest.json"
					parse: 'json'
				exchange:
					url: exchangeUrl
					parse: 'cson'
				#'twitter-favorites': url: 'https://api.twitter.com/1.1/favorites/list.json?screen_name=docpad&count=200&include_entities=true'

		repocloner:
			repos: [
				name: 'DocPad Documentation'
				path: 'src/documents/learn/docpad/documentation'
				url: 'https://github.com/bevry/docpad-documentation.git'
			]

		cleanurls:
			# Common Redirects
			simpleRedirects:
				'/license': '/g/blob/master/LICENSE.md#readme'
				'/chat-logs': 'https://botbot.me/freenode/docpad/'
				'/chat': 'http://webchat.freenode.net/?channels=docpad'
				'/changelog': '/g/blob/master/HISTORY.md#readme'
				'/changes': '/changelog'
				'/history': '/changelog'
				'/bug-report': '/docs/support#bug-reports-via-github-s-issue-tracker'
				'/forum': 'http://stackoverflow.com/questions/tagged/docpad'
				'/stackoverflow': '/forum'
				'/google+': 'https://plus.google.com/communities/102027871269737205567'
				'/+': '/google+'
				'/donate': 'https://bevry.me/donate'
				'/gittip-community': '/donate'
				'/gittip': '/donate'
				'/gratipay-community': '/donate'
				'/gratipay': '/donate'
				'/flattr': '/donate'
				'/praise': 'https://twitter.com/docpad/favorites'
				'/growl': 'http://growl.info/downloads'
				'/partners': '/docs/support#support-consulting-partners'
				'/contributors': '/docs/participate#contributors'
				'/docs/start': '/docs/begin'
				'/get-started': '/docs/overview'
				'/chat-guidelines': '/i/384'
				'/unstable-node': '/i/725'
				'/render-early-via-include': '/i/378'
				'/extension-not-rendering': '/i/192'
				'/plugin-conventions': '/i/313'
				'/plugin-uncompiled': '/i/925'

			advancedRedirects: [
				# Old URLs
				[/^https?:\/\/(?:refresh\.docpad\.org|docpad\.herokuapp\.com|docpad\.github\.io\/website)(.*)$/, 'https://docpad.org$1']

				# Short Links
				[/^\/(plugins|upgrade|install|troubleshoot)\/?$/, '/docs/$1']

				# Content
				# /docpad[/#{relativeUrl}]
				[/^\/docpad(?:\/(.*))?$/, '/docs/$1']

				# Bevry Content
				[/^\/((?:tos|terms|privacy).*)$/, 'https://bevry.me/$1']

				# Learning Centre Content
				[/^\/((?:node|joe|query-?engine).*)$/, 'https://learn.bevry.me/$1']

				# GitHub
				# /(g|github|bevry/docpad)[/#{path}]
				[/^\/(?:g|github|bevry\/docpad)(?:\/(.*))?$/, 'https://github.com/docpad/docpad/$1']

				# Twitter
				[/^\/(?:t|twitter|tweet)(?:\/(.*))?$/, 'https://twitter.com/docpad']

				# Issues
				# /(i|issue)[/#{issue}]
				[/^\/(?:i|issues)(?:\/(.*))?$/, 'https://github.com/docpad/docpad/issues/$1']

				# Plugins
				# /(p|plugin)/#{pluginName}
				[/^\/(?:p|plugin)\/(.+)$/, 'https://github.com/docpad/docpad-plugin-$1']

				# Plugins via Full (legacy)
				# /(docs/)?docpad-plugin-#{pluginName}
				[/^\/(?:docs\/)?docpad-plugin-(.+)$/, 'https://github.com/docpad/docpad-plugin-$1']
			]

	# =================================
	# Environments

	# Disable analytic services on the development environment
	environments:
		development:
			templateData:
				site:
					services:
						gauges: false
						googleAnalytics: false
						mixpanel: false
						reinvigorate: false
			plugins:
				repocloner:
					repos: []
		production:
			maxAge: false
			# maxAge: false

			hostname: process.env.OPENSHIFT_NODEJS_IP || '127.0.0.1'
			# Listen to port 8082 on the development environment
			port: process.env.PORT || process.env.OPENSHIFT_NODEJS_PORT || process.env.OPENSHIFT_INTERNAL_PORT || 9778

	# =================================
	# Events

	events:

		# Extend Template data
		extendTemplateData: (opts) ->
			opts.templateData.moment = require('moment')
			opts.templateData.strUtil = require('underscore.string')

			# Return
			return true

		# Generate Before
		generateBefore: (opts) ->
			# Reset contributors if we are a complete generation (not a partial one)
			contributors = null

			# Return
			return true

		# Fetch Contributors
		renderBefore: (opts,next) ->
			# Prepare
			docpad = @docpad

			# Check
			return next()  if contributors

			# Log
			docpad.log('info', 'Fetching your latest contributors for display within the website')

			# Prepare contributors getter
			contributorsGetter ?= require('getcontributors').create(
				#log: docpad.log
				github_client_id: process.env.BEVRY_GITHUB_CLIENT_ID
				github_client_secret: process.env.BEVRY_GITHUB_CLIENT_SECRET
			)

			# Fetch contributors
			contributorsGetter.fetchContributorsFromUsers ['bevry','docpad','webwrite'], (err,_contributors=[]) ->
				# Check
				return next(err)  if err

				# Apply
				contributors = _contributors
				docpad.log('info', "Fetched your latest contributors for display within the website, all #{_contributors.length} of them")

				# Complete
				return next()

			# Return
			return true

# Export our DocPad Configuration
module.exports = docpadConfig

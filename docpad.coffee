functions = {
    
    makeSlug: (title) ->
        title.replace(/[^a-zA-Zא-ת0-9\s_-]/gi, '').replace(/[\s_-]+/gi, '-').replace(/\-{2,}/gi, '-')

    getYoutubeEmbed: (url) ->
        regexp = /.*youtube\.com.*v=(\w+)/g
        matches = regexp.exec(url);
        
        if matches[1] then "//www.youtube.com/embed/" + matches[1] else ""
}



# DocPad Configuration
docpadConfig = {

    collections:
        ###
        default: ->
            @getCollection("html").findAllLive().on 'add', (document) ->
                permalink = document.get('permalink')
                #unless permalink
                #    permalink = functions.makeSlug(document.get('title'))
                #document.set('filename', permalink)
        ###
        books: ->
            @database.findAll({relativeOutDirPath: /books/}).on 'add', (document) ->
                document.setMetaDefaults({layout:"book"})

        courses: ->
            @database.findAll({relativeOutDirPath: /courses/}).on 'add', (document) ->
                document.setMetaDefaults({layout:"course"})

        blogs: ->
            @database.findAll({relativeOutDirPath: /blogs/}).on 'add', (document) ->
                document.setMetaDefaults({layout:"blog"})

    documentPaths: ['documents', 'supportDocuments']

    watchOptions:
        preferredMethods: ['watchFile', 'watch']

    ignoreHiddenFiles: true
    regenerateDelay: 20

    pulgins:

        sitemap:
            cachetime: 600000
            changefreq: 'monthly'
            priority: 1

        ghpages:
            deployRemote: 'betatarget'
            deployBranch: 'gh-pages'

# =================================
# Template Configuration

# Template Data
# Use to define your own template data and helpers that will be accessible to your templates
# Complete listing of default values can be found here: http://docpad.org/docs/template-data
    templateData: # example

    # Specify some site properties
        site:
        # The production url of our website
            url: "http://learningsummaries.com"

        # The default title of our website
            title: "Summaries of things we learn (book summaries, courses, articles)"

        # The website description (for SEO)
            description: "Summaries of knowledge extracted from book, oncline courses, blogs and observations"

        # The website keywords (for SEO) separated by commas
            keywords: "summorize, summorize learning, knowledge, book summary, course summary"


    # -----------------------------
    # Helper Functions

    # Get the prepared site/document title
    # Often we would like to specify particular formatting to our page's title
    # we can apply that formatting here
        getPreparedTitle: ->
            # if we have a document title, then we should use that and suffix the site's title onto it
            if @document.title
                @document.title
                # if our document does not have it's own title, then we should just use the site's title
            else
                @site.title

    # Get the prepared site/document description
        getPreparedDescription: ->
            desc = if @document.description then @document.description + '. ' else ''
            # if we have a document description, then we should use that, otherwise use the site's description
            desc + @site.description

    # Get the prepared site/document keywords
        getPreparedKeywords: ->
            # Merge the document keywords with the site keywords
            @site.keywords.concat(@document.keywords or []).join(', ')

        getPostPreview: ->
            functions.getPostPreview @document


        getYoutubeEmbed: (url)->
            console.log 'called with url ', url
            functions.getYoutubeEmbed url



    events:
        serverExtend: (opts) ->
            opts.server.get '*.gz.*', (req, res, next) ->
                res.set('Content-Encoding', 'gzip');
                next()
}



# Export the DocPad Configuration
module.exports = docpadConfig

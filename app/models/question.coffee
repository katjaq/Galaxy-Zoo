Spine = require 'spine'

class Question extends Spine.Model
  @configure 'Question', 'tree', 'title', 'text', 'answers', 'checkboxes', 'leadsTo'
  
  @findByTreeAndText: (tree, text) ->
    @select (q) -> q.tree is tree and q.text is text
  
  @firstForTree: (tree) ->
    @find "#{ tree }-0"
  
  constructor: (hash) ->
    count = Question.findAllByAttribute('tree', hash.tree).length
    @id or= "#{ hash.tree }-#{ count }"
    @answers or= { }
    @checkboxes or= { }
    hash.answerWith?.apply @
    super
  
  answer: (text, { leadsTo: leadsTo, icon: icon } = { leadsTo: null, icon: null }) ->
    @answers["a-#{ _(@answers).keys().length }"] = { text, leadsTo, icon }
  
  checkbox: (text, { icon: icon } = { icon: null }) ->
    checkbox = true
    @checkboxes["x-#{ _(@checkboxes).keys().length }"] = { checkbox, text, icon }
  
  nextQuestionFrom: (answer) ->
    text = @answers[answer]?.leadsTo or @leadsTo
    question = @constructor.findByTreeAndText @tree, text
    question[0] or null

module.exports = Question

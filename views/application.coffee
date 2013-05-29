$(document).ready ->

  cypherResult = (selector, data) ->
    addField = (ul, data) ->
      for field of data
        li = $('<li>')
        if typeof(data[field]) == 'object'
          ulNested = $('<ul>')
          addField ulNested, data[field]
          li.append ulNested
        else
          label = $('<b>', text: field + ' ')
          li.append(label).append($('<span>', text: data[field]))
        ul.append li

    ul = $('<ul>', class: 'cypher-data')
    selector.append ul
    addField ul, data


  launchCypher = (container, query) ->
    container.find('textarea').removeClass('error')
    container.find('span.error').text('')
    container.find('.time').text('')

    $.ajax(
      url: "/api/v1/launch_cypher"
      type: "POST"
      data: { query }
      success: (data) ->
        container.find('p.result').text('')
        cypherResult(container.find('p.result'), data.result.data)
        container.find('.time').text(data.time + ' seconds')

      error: (response) ->
        container.find('.cypherQuery').addClass('error')
        container.find('span.error').text(response.statusText)
    )



  $('button.launchCypher').click ->
    launchCypher $('.launch-cypher'), $('.cypherQuery').val()

  $('button.actorsWithSameStar').click ->
    query = "START actor1=node(*) MATCH actor1-[:make]->event<-[:make]-actor2
      WHERE event.type = 'WatchEvent' AND NOT actor1 = actor2 RETURN actor1.login, actor2.login, event.url;"
    launchCypher $('.examples'), query

  $('button.cypherResults').click ->
    results = $(@).closest('div.results')
    results.find('p.result').toggle()

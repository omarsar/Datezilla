@BlindDate = React.createClass

    handleSubmit: (e) ->
      e.preventDefault()

      $('.btn').mouseup ->
        $(this).blur()
        return
      
      @setState followValue: "Disable blinddating"
      @setState showFollowing: true
      $.ajax
        url: "/users/#{@state.userId}/turnonbd"
        type: 'PUT'
        data: 
          user: @state.userId
    

    handleSubmitUnFollow: (e) ->
      e.preventDefault()

      $('.btn').mouseup ->
        $(this).blur()
        return

      @setState followValue: "Enable blinddating"
      @setState showFollowing: false
      $.ajax
        url: "/users/#{@state.userId}/turnoffbd"
        type: 'PUT'
        data: 
          user: @state.userId


    getInitialState: ->

      $('.btn').mouseup ->
        $(this).blur()
        return

      followValue: @props.followValue 
      showFollowing: @props.showFollowing
      userId: @props.userId

    render: ->
      if @state.showFollowing
        React.DOM.button
          className: 'btn btn-danger btn-xs'
          style: {width:'100%'}
          onClick: @handleSubmitUnFollow
          React.DOM.i
            className: 'fa fa-check'
          React.DOM.span style:{'paddingLeft':'2px'}, @state.followValue
      else
        React.DOM.button
          className: 'btn btn-success btn-xs'
          style: {width:'100%'}
          onClick: @handleSubmit
          React.DOM.i
            className: 'fa fa-power-off'
          React.DOM.span style:{'paddingLeft':'2px'}, @state.followValue

      
@BlindDate = React.createClass

    handleSubmit: (e) ->
      e.preventDefault()

      $('.btn').mouseup ->
        $(this).blur()
        return
      
      @setState followValue: "Following"
      @setState showFollowing: true
      $.ajax
        url: "/interests/#{@state.userId}/follow"
        type: 'PUT'
        data: 
          user: @state.userId
    

    handleSubmitUnFollow: (e) ->
      e.preventDefault()

      $('.btn').mouseup ->
        $(this).blur()
        return

      @setState followValue: "Follow"
      @setState showFollowing: false
      $.ajax
        url: "/interests/#{@state.userId}/unfollow"
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
          className: 'btn btn-primary btn-xs'
          style: {width:'100%'}
          onClick: @handleSubmitUnFollow
          React.DOM.i
            className: 'fa fa-check'
          React.DOM.span style:{'paddingLeft':'2px'}, @state.followValue
      else
        React.DOM.button
          className: 'btn btn-vote btn-xs'
          style: {width:'100%'}
          onClick: @handleSubmit
          React.DOM.i
            className: 'fa fa-plus'
          React.DOM.span style:{'paddingLeft':'2px'}, @state.followValue

      
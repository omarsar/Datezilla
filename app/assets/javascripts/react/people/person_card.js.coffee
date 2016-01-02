# @cjsx React.DOM

@PersonCard = React.createClass
  displayName: 'PersonCard'
  render: ->
    #cx = React.addons.classSet
    cardClasses = React.addons.createFragment(
      'card': true
      'female': @props.data.gender == 'female'
      'male': @props.data.gender == 'male')

    <div className={cardClasses}>
      <header>
        <div className="avatar-wrapper">
          &nbsp;
          <img className="circle" src={@props.data.user.avatar} />
        </div>

        <div className="info-wrapper">
          <h4>{@props.data.user.username}</h4>
          <ul className="meta"> 
            <li><i className="fa fa-map-marker"></i> {@props.data.location}</li>
            <li><i className="fa fa-birthday-cake"></i> {moment(@props.data.birth_date).format('D MMM YYYY')}</li>
          </ul>
        </div>
      </header>
      <div className="card-body">
        <div className="headline">
          <p>{@props.data.headline}</p>
        </div>
        <ul className="contact-info">
          <li><i className="fa fa-phone"></i> {@props.data.phone_number}</li>
          <li><i className="fa fa-envelope"></i> {@props.data.user.email}</li>
        </ul>
      </div>
    </div>
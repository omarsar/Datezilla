class Interest 
  include Neo4j::ActiveNode

  #title propoerty must be unique
  property :title, type: String#, constraint: :unique #, index: :exact, 
  index :title
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :score, type: Integer, default: 0

  #defining the relationships
  #has_many :in, :author, type: :user, model_class: :User
  has_many :in, :followed_by, model_class: :User, origin: :interests


  #function for icnementing score to create ranking mechanism for interest
  #before_save do
  #	self.score = score + 1
  #end


end

class Interest 
  include Neo4j::ActiveNode

  #title propoerty must be unique
  property :title, type: String#, constraint: :unique #, index: :exact, 
  index :title
  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  #defining the relationships
  #has_many :out, :author, type: :user, model_class: :User

end
